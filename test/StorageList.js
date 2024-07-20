const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("StorageList", function () {
  let StudentStorage, studentStorage;

  beforeEach(async function () {
    StudentStorage = await ethers.getContractFactory("StorageList");
    studentStorage = await StudentStorage.deploy();

  });




  it("获取list", async function () {
    const userList = await studentStorage.getList();
    console.log(userList);
    expect(userList).deep.equal([]);
    // expect(name).to.equal("");
    // expect(age).to.equal(0);
  });

  it("addList添加list", async function () {
    const tx = await studentStorage.addList("Alice", 21);

    // await tx.wait(); // 等待事务被矿工打包写入区块链
    const userList = await studentStorage.getList();
    console.log(userList);

    // 将返回的结果转换为预期的对象格式
    const formattedUserList = userList.map(([id, name, age]) => ({
      id: id.toString(),
      name: name,
      age: age
    }));
    expect(formattedUserList).deep.equal([{
      id: "1",
      name: "Alice",
      age: 21
    }]);
    // expect(name).to.equal("Alice");
    // expect(age).to.equal(21);
  });
});
