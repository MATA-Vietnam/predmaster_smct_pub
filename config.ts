export default {
    Address: {
      Oracle: {
        mainnet: "0x0000000000000000000000000000000000000000",
        testnet: "0x1bdfaEEDc76Eb89274d60f240D519F6Fd50554A4",
      },
      Admin: {
        mainnet: "0x0000000000000000000000000000000000000000",
        testnet: "0x4B96dAfBb33fB27D0821a989CeBb88FAbB5b3238",
      },
      Operator: {
        mainnet: "0x0000000000000000000000000000000000000000",
        testnet: "0x4B96dAfBb33fB27D0821a989CeBb88FAbB5b3238",
      },
    },
    Block: {
      Interval: {
        mainnet: 300,
        testnet: 300,
      },
      Buffer: {
        mainnet: 60,
        testnet: 60,
      },
    },
    Treasury: {
      mainnet: 300, // 3%
      testnet: 1000, // 10%
    },
    BetAmount: {
      mainnet: 0.001,
      testnet: 0.001,
    },
    OracleUpdateAllowance: {
      mainnet: 300,
      testnet: 300,
    },
  };
  