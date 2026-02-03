import { SiweMessage } from 'siwe';
import { createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { base } from 'viem/chains';

const account = privateKeyToAccount(process.env.EVM_PRIVATE_KEY);

const siweMessage = new SiweMessage({
  domain: 'api.clawdvine.sh',
  address: account.address,
  statement: 'Sign in to ClawdVine Agentic Media Network',
  uri: 'https://api.clawdvine.sh',
  version: '1',
  chainId: 8453,
  nonce: crypto.randomUUID().replace(/-/g, '').slice(0, 16),
});

const message = siweMessage.prepareMessage();

const walletClient = createWalletClient({
  account,
  chain: base,
  transport: http(),
});

const signature = await walletClient.signMessage({ message });

const headers = {
  'X-EVM-SIGNATURE': signature,
  'X-EVM-MESSAGE': Buffer.from(message).toString('base64'),
  'X-EVM-ADDRESS': account.address,
};

console.log(JSON.stringify(headers));
