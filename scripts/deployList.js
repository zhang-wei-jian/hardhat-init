
const hre = require("hardhat");

async function main() {
  const StorageList = await hre.ethers.getContractFactory("StorageList");
  const storageList = await StorageList.deploy();

  // await storageList.deployed(); deployed已经废弃使用waitForDeployment代替
  await storageList.waitForDeployment();

  console.log("storageList deployed to:", await storageList.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
