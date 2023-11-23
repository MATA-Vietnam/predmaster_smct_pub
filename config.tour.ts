export default {
  Address: {
    Admin: {
      mainnet: "0x0000000000000000000000000000000000000000",
      testnet: "0x48b13E0423DD609B238B89a9Ffaf9247d354025D",
    },
    Operator: {
      mainnet: "0x0000000000000000000000000000000000000000",
      testnet: "0x48b13E0423DD609B238B89a9Ffaf9247d354025D",
    },
  },
  Block: {
    Interval: {
      mainnet: 180,
      testnet: 180,
    },
    Buffer: {
      mainnet: 60,
      testnet: 60,
    },
  },
  Treasury: {
    mainnet: 1000, // 3%
    testnet: 0, // 10%
  },
  BetAmount: {
    mainnet: 1,
    testnet: 2,
  },
  OracleUpdateAllowance: {
    mainnet: 300,
    testnet: 300,
  },
};
