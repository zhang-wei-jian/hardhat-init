const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { ethers } = require("hardhat");


module.exports = buildModule("exChange", (m) => {
  // 获取签名者（可选，根据你的需求）

  // 定义合约，传递构造函数参数
  const ZWJToken = m.contract("ZWJToken");
  const ExChange = m.contract("ExChange", ["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", 10]); // 使用获取的签名者地址和费率

  // 返回部署的合约实例
  return { ZWJToken, ExChange };
});
