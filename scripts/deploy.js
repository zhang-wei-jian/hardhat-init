const hre = require("hardhat");

async function main() {
  const StudentStorage = await hre.ethers.getContractFactory("StudenStorage");
  const studentStorage = await StudentStorage.deploy();

  // await studentStorage.deployed(); deployed已经废弃使用waitForDeployment代替
  await studentStorage.waitForDeployment();

  console.log("studentStorage deployed to:", await studentStorage.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
