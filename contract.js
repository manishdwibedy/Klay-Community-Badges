// load env file
import dotenv from 'dotenv';
import { Contract, ethers, Wallet } from 'ethers';
import  ABI  from './contact_abi.js'

dotenv.config();

const WALLET_PRIVATE_KEY = process.env.ACCOUNT_KEY;
const RPC_ENDPOINT = process.env.RPC_ENDPOINT;
if (!ACCOUNT_KEY) {
  throw new Error('Account private key not provided in env file');
}

if (!RPC_ENDPOINT) {
  throw new Error('RPC endpoint not provided in env file');
}

// ERC 721 Contract Address
const CONTRACT_ADDRESS = '0xE9eAa9C448c3Ed3313f7c1a81F4811BC9373f339';

// ERC 721 Contract ABI
const CONTRACT_ABI = ABI; // The contract ABI

// Works for ethers V6.x
// const provider = new caver.providers.HttpProvider(RPC_ENDPOINT);

// Works for ethers V5.x
const provider = new ethers.providers.JsonRpcProvider(RPC_ENDPOINT);

// account key loaded from env file previously
const signer = new ethers.Wallet(WALLET_PRIVATE_KEY, provider);

const balance = await signer.getBalance();
console.log(`Balance is ${ethers.utils.formatEther(balance)}`);

const contractInstance = new Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);

// wrap code in async function
async function sendTransaction() {
  const unsignedTrx = await contractInstance.safeMint(
    '0x58C70f6a8c2A8c9d13778915EC6B9617192911cc',
    'https://manishdwibedy.github.io/Klay-Community-Badges/token-uri.json'
  );

  console.log('Transaction created');
  await unsignedTrx.wait(1);
  console.log(`NFT has been mined. Transaction hash: ${unsignedTrx.hash}`);
}

// trigger sendTransaction function
sendTransaction().then(() => console.log('Completed'));