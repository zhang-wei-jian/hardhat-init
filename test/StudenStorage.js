const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("StudenStorage", function () {
  let StudentStorage, studentStorage;

  beforeEach(async function () {
    StudentStorage = await ethers.getContractFactory("StudenStorage");
    studentStorage = await StudentStorage.deploy();

  });




  it("应该初始化为默认值", async function () {
    const [name, age] = await studentStorage.getData();
    expect(name).to.equal("");
    expect(age).to.equal(0);
  });

  it("应该更新数据", async function () {
    const tx = await studentStorage.setData("Alice", 21);

    // await tx.wait(); // 等待事务被矿工打包写入区块链
    const [name, age] = await studentStorage.getData();
    console.log("name:", name);
    console.log("age:", age);

    expect(name).to.equal("Alice");
    expect(age).to.equal(21);
  });
});
