import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

const config = {
  defaultNetwork: "testnet",
  networks: {
    testnet: {
      url: "https://data-seed-prebsc-2-s1.bnbchain.org:8545",
      accounts: [
        "0x707fd496043bec149664f960be2f3644xxxxxxxxxxxxxxxxxxxxxxx", //privatekey
      ],
      gasPrice: 10000000000,
    },
    sellSlot: {
      url: "https://bsc-dataseed2.binance.org",
      accounts: [
        "abc10d630d5a788bf2eb2a478e20axxxxxxxxxxxxxxxxxxxxxxxxxxxxx", //privatekey
      ],
    },
    
  },
  etherscan: {
    apiKey: "xxxxxxxxxx", // BSCSCAN API KEY
  },
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};

export default config;
