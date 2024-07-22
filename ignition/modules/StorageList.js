const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// const StorageListModule = buildModule("StorageListModule", (m) => {
module.exports = buildModule("StorageListModule", (m) => {
  // 直接定义合约，因为没有构造函数参数
  const storageList = m.contract("StorageList");

  // 返回部署的合约实例
  return { storageList };
});








