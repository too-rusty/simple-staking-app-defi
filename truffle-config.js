
// const HDWalletProvider = require('@truffle/hdwallet-provider');
// require('dotenv').config()

// const mnemonic = process.env.MNEMONIC
// const url = process.env.RPC_URL
// https://rinkeby.infura.io/v3/<PROJECT-ID> // for interacting with rinkeby chain

module.exports = {
  /**
   * $ truffle test --network <network-name>
   */
  networks: {
    // development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 8545,            // Standard Ethereum port (default: none)
    //  network_id: "*",       // Any network (default: none)
    // }, // start ganache-cli before this
    // bsc_testnet: {
    //   provider: () => new HDWalletProvider(mnemonic,'https://data-seed-prebsc-1-s1.binance.org:8545'),
    //   network_id: 97,
    //   confirmations: 10,
    //   timeoutBlocks: 200,
    //   skipDryRun: true
    // },
    // rinkeby: {
    //   provider: () => {
    //     return new HDWalletProvider(mnemonic, url)
    //   },
    //   network_id: '4',
    //   skipDryRun: true
    // },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  },

};