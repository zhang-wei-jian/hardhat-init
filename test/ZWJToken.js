const { expect } = require("chai");
const { ethers } = require("hardhat");
const { formatEther, parseEther } = require("ethers");


describe("ZWJToken", function () {

  let StudentStorage, studentStorage;
  let owner, addr1, addr2;
  beforeEach(async function () {
    StudentStorage = await ethers.getContractFactory("ZWJToken");
    studentStorage = await StudentStorage.deploy();
    [owner, addr1, addr2] = await ethers.getSigners();
  });




  it("验证name", async function () {
    const name = await studentStorage.name();
    console.log(name);
    expect(name).deep.equal("ZWJToken");
    // expect(name).to.equal("");
    // expect(age).to.equal(0);
  });


  it("验证代号symbol", async function () {
    const name = await studentStorage.symbol();
    console.log(name);
    expect(name).deep.equal("ZWJ");
    // expect(name).to.equal("");
    // expect(age).to.equal(0);
  });

  it("TEST", async function () {


    console.log("decimals", await studentStorage.decimals());
    console.log("totalSupply", await studentStorage.totalSupply());
    console.log("balanceOf", await studentStorage.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"));
    console.log(formatEther(await studentStorage.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));

    // expect(name).deep.equal("ZWJ");

  });

  it("transfer转账", async function () {

    // 转账方式1
    await studentStorage.transfer("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199", parseEther("1.0"), {
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    })
    // 转账方式2
    await studentStorage.connect(owner).transfer("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199", parseEther("1.0"));
    console.log("转账后");

    console.log("账号1", formatEther(await studentStorage.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));
    console.log("账号2", formatEther(await studentStorage.balanceOf("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199")));


    // expect(name).deep.equal("ZWJ");

  });



});
