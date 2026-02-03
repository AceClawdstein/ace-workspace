import { createPublicClient, http, parseAbi } from 'viem';
import { base } from 'viem/chains';

const CLAWDVINE_TOKEN = '0x963e83082e0500ce5Da98c78E79A49C09084Bb07';
const MIN_BALANCE = 10_000_000n;

const address = process.argv[2];
if (!address) {
  console.error('Usage: node check-balance.mjs <address>');
  process.exit(1);
}

const client = createPublicClient({ chain: base, transport: http() });

const balance = await client.readContract({
  address: CLAWDVINE_TOKEN,
  abi: parseAbi(['function balanceOf(address) view returns (uint256)']),
  functionName: 'balanceOf',
  args: [address],
});

const decimals = await client.readContract({
  address: CLAWDVINE_TOKEN,
  abi: parseAbi(['function decimals() view returns (uint8)']),
  functionName: 'decimals',
});

const humanBalance = balance / BigInt(10 ** Number(decimals));
const hasEnough = humanBalance >= MIN_BALANCE;

console.log(`Address: ${address}`);
console.log(`$CLAWDVINE Balance: ${humanBalance.toLocaleString()}`);
console.log(`Required: ${MIN_BALANCE.toLocaleString()}`);
console.log(`Status: ${hasEnough ? '✅ Eligible to join' : '❌ Need more tokens'}`);
