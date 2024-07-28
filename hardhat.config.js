require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition");


module.exports = {
  solidity: "0.8.24",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337  // 默认 Hardhat 本地网络链 ID
    },
    ropsten: {
      url: "http://192.168.31.64:8545", // 使用 Infura 提供的 Ropsten URL
      accounts: ["0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356"], // 使用部署合约的账户私钥
      chainId: 31337  // 默认 Hardhat 本地网络链 ID
    },
  },
};
