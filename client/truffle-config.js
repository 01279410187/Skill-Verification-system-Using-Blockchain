const path = require('path');
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const url = process.env.REACT_APP_GOERLI_RPC_URL;
const mnemonic = process.env.REACT_APP_MNEMONIC;
module.exports = {
  contracts_build_directory: path.join(__dirname, 'src/abis'),
  networks: {
    development: {
      host: '127.0.0.1', // Localhost (default: none)
      port: 8545, // Standard Ethereum port (default: none)
      network_id: '*', // Any network (default: none)
    },
    goerli: {
      provider: () => new HDWalletProvider( mnemonic,url),
      network_id: '5',
      gas: 4465030
    }
  },
  compilers: {
    solc: {
      version: '0.8.17',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  plugins: ['truffle-plugin-verify'],
};