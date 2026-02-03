import { wrapFetchWithPayment, x402Client } from '@x402/fetch';
import { registerExactEvmScheme } from '@x402/evm/exact/client';
import { privateKeyToAccount } from 'viem/accounts';
import { readFileSync } from 'fs';

const API_BASE = 'https://api.clawdvine.sh';

// Setup x402 client
const privateKey = process.env.EVM_PRIVATE_KEY;
if (!privateKey) {
  console.error('EVM_PRIVATE_KEY required');
  process.exit(1);
}

const signer = privateKeyToAccount(privateKey);
const client = new x402Client();
registerExactEvmScheme(client, { signer });
const fetchWithPayment = wrapFetchWithPayment(fetch, client);

// Get args
const prompt = process.argv[2] || 'A sunset over mountains';
const model = process.argv[3] || 'xai-grok-imagine';
const duration = parseInt(process.argv[4] || '8');
const agentId = process.env.CLAWDVINE_AGENT_ID || process.argv[5];
const imageDataPath = process.argv[6]; // Optional path to JSON with imageData

// Build request body
let body = { prompt, videoModel: model, duration };
if (agentId) body.agentId = agentId;

// Load image data if provided
if (imageDataPath) {
  try {
    const data = JSON.parse(readFileSync(imageDataPath, 'utf8'));
    if (data.imageData) body.imageData = data.imageData;
  } catch (e) {
    console.error('Failed to load image data:', e.message);
  }
}

console.log('🎬 Generating video...');
console.log(`   Prompt: ${prompt.slice(0, 60)}...`);
console.log(`   Model: ${model}`);
console.log(`   Duration: ${duration}s`);
console.log(`   Agent: ${agentId || 'anonymous'}`);

try {
  const response = await fetchWithPayment(`${API_BASE}/generation/create`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    const err = await response.text();
    console.error('❌ Generation failed:', err);
    process.exit(1);
  }

  const { taskId, status } = await response.json();
  console.log(`✅ Task created: ${taskId}`);
  console.log(`   Status: ${status}`);

  // Poll for completion
  console.log('⏳ Polling for completion...');
  let complete = false;
  let result;
  
  while (!complete) {
    await new Promise(r => setTimeout(r, 5000));
    
    const statusRes = await fetch(`${API_BASE}/generation/${taskId}/status`);
    const statusData = await statusRes.json();
    
    console.log(`   Status: ${statusData.status} ${statusData.metadata?.percent ? `(${statusData.metadata.percent}%)` : ''}`);
    
    if (statusData.status === 'completed') {
      complete = true;
      result = statusData.result;
    } else if (statusData.status === 'failed') {
      console.error('❌ Generation failed:', statusData.error);
      process.exit(1);
    }
  }

  console.log('\n🎉 Video generated!');
  console.log(`   Video: ${result.generation.video}`);
  console.log(`   Preview: ${result.generation.image}`);
  console.log(`   GIF: ${result.generation.gif}`);
  
  // Output just the video URL for piping
  console.log(`\nVIDEO_URL=${result.generation.video}`);

} catch (err) {
  console.error('❌ Error:', err.message);
  process.exit(1);
}
