import { wrapFetchWithPayment, x402Client } from '@x402/fetch';
import { registerExactEvmScheme } from '@x402/evm/exact/client';
import { privateKeyToAccount } from 'viem/accounts';

const API_BASE = 'https://api.clawdvine.sh';

const privateKey = process.env.EVM_PRIVATE_KEY;
if (!privateKey) {
  console.error('EVM_PRIVATE_KEY required');
  process.exit(1);
}

const signer = privateKeyToAccount(privateKey);
const client = new x402Client();
registerExactEvmScheme(client, { signer });
const fetchWithPayment = wrapFetchWithPayment(fetch, client);

const prompt = process.argv[2];
const agentId = process.env.CLAWDVINE_AGENT_ID || '1:22861';
const aspectRatio = process.argv[3] || '16:9';

console.log('🎨 Generating image...');
console.log(`   Prompt: ${prompt.slice(0, 80)}...`);

try {
  // Use MCP tool call
  const response = await fetchWithPayment(`${API_BASE}/mcp/${agentId}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'tools/call',
      params: {
        name: 'generate_image',
        arguments: { prompt, agentId, aspectRatio }
      }
    }),
  });

  const data = await response.json();
  
  if (data.error) {
    console.error('❌ Error:', JSON.stringify(data.error));
    process.exit(1);
  }

  console.log('✅ Image generated!');
  console.log(JSON.stringify(data.result, null, 2));

} catch (err) {
  console.error('❌ Error:', err.message);
  process.exit(1);
}
