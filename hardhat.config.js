require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition");


module.exports = {
  solidity: "0.8.24",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337  // 默认 Hardhat 本地网络链 ID
    },
  },
};
