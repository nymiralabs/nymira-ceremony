#!/usr/bin/env node
// Finds the first final NEAR mainnet block whose header timestamp is at or after T, fetches it from
// three independent providers and one archival node, compares the hashes, stores the raw JSON and
// prints the beacon: the block hash, base58 decoded to 32 bytes, as lowercase hex.
// usage: node fetch-beacon.mjs 2026-11-07T00:00:00Z OUTPUT_DIRECTORY
// Node 24, no dependencies. Skipped heights are normal on NEAR; the search steps over them.
import { mkdirSync, writeFileSync } from 'node:fs';

const [, , when, outDir] = process.argv;
if (!when || !outDir) throw new Error('usage: fetch-beacon.mjs TIMESTAMP_UTC OUTPUT_DIRECTORY');
const target = BigInt(Date.parse(when)) * 1_000_000n;
if (!/Z$/.test(when)) throw new Error('timestamp must end in Z (UTC)');
const PROVIDERS = [
  'https://rpc.mainnet.near.org',
  'https://free.rpc.fastnear.com',
  'https://rpc.shitzuapes.xyz',
];
const ARCHIVAL = 'https://archival-rpc.mainnet.fastnear.com';

async function rpc(url, params) {
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ jsonrpc: '2.0', id: 1, method: 'block', params }),
    signal: AbortSignal.timeout(20_000),
  });
  return { text: await res.text() };
}
async function block(url, params) {
  const { text } = await rpc(url, params);
  const json = JSON.parse(text);
  if (json.error) return { missing: true, text };
  return { block: json.result, text };
}
// The block at `height`, or the next existing one.
async function at(url, height) {
  for (let h = height; h < height + 50; h++) {
    const r = await block(url, { block_id: h });
    if (!r.missing) return r;
  }
  throw new Error(`no block in 50 heights from ${height}`);
}

// The exact nanosecond timestamp is a string in the block header (`timestamp_nanosec`); the
// numeric `timestamp` is parsed as a double and loses the last three digits.
const ts = (h) => BigInt(h.timestamp_nanosec ?? h.timestamp);
const head = (await block(ARCHIVAL, { finality: 'final' })).block.header;
if (ts(head) < target) throw new Error('the target time has not passed on the final head yet');
// NEAR makes at most about 3 blocks a second, so the block cannot lie further back than this.
const secondsAgo = Number((ts(head) - target) / 1_000_000_000n);
let lo = Math.max(1, head.height - (secondsAgo + 60) * 3), hi = head.height;
// invariant: ts(at(hi)) >= target; the first such block is at or after lo
while (lo < hi) {
  const mid = Math.floor((lo + hi) / 2);
  const b = (await at(ARCHIVAL, mid)).block.header;
  if (ts(b) >= target) hi = b.height < hi ? b.height : mid; else lo = b.height + 1;
}
const found = (await at(ARCHIVAL, lo)).block.header;
const prev = (await block(ARCHIVAL, { block_id: found.prev_hash })).block.header;
if (!(ts(found) >= target && ts(prev) < target)) throw new Error('search ended on a wrong block');

mkdirSync(outDir, { recursive: true });
const hashes = {};
for (const [i, url] of [...PROVIDERS, ARCHIVAL].entries()) {
  const r = await block(url, { block_id: found.height });
  if (r.missing) throw new Error(`${url} does not have height ${found.height}: ${r.text}`);
  writeFileSync(`${outDir}/block-${found.height}.provider${i}.json`, r.text + '\n');
  hashes[url] = r.block.header.hash;
}
const distinct = new Set(Object.values(hashes));
if (distinct.size !== 1) throw new Error('providers disagree: ' + JSON.stringify(hashes));
const hash = [...distinct][0];

const ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
let n = 0n;
for (const c of hash) {
  if (ALPHABET.indexOf(c) < 0) throw new Error(`not a base58 character in the block hash: ${c}`);
  n = n * 58n + BigInt(ALPHABET.indexOf(c));
}
const hex = n.toString(16).padStart(64, '0');
if (hex.length !== 64) throw new Error('hash is not 32 bytes');
const record = {
  rule: `first final NEAR mainnet block with header timestamp >= ${when}`,
  height: found.height,
  timestamp_ns: ts(found).toString(),
  previous_block_timestamp_ns: ts(prev).toString(),
  hash_base58: hash,
  beacon_hex: hex,
  providers: hashes,
};
writeFileSync(`${outDir}/beacon.json`, JSON.stringify(record, null, 2) + '\n');
console.log(JSON.stringify(record, null, 2));
