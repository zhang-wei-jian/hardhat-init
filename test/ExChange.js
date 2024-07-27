



const { expect } = require("chai");
const { ethers } = require("hardhat");
const { formatEther, parseEther } = require("ethers");


describe("ZWJToken", function () {

  let ZWJToken, zwjToken;
  let ExChange, exChange;

  let owner, addr1, addr2;
  beforeEach(async function () {
    ZWJToken = await ethers.getContractFactory("ZWJToken");
    ExChange = await ethers.getContractFactory("ExChange");

    zwjToken = await ZWJToken.deploy();
    exChange = await ExChange.deploy("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", 10);


    [owner, addr1, addr2] = await ethers.getSigners();
  });




  it("验证name", async function () {
    const name = await zwjToken.name();
    console.log(name);
    expect(name).deep.equal("ZWJToken");

  });


  it("验证代号symbol", async function () {
    const name = await zwjToken.symbol();
    console.log(name);
    expect(name).deep.equal("ZWJ");
    // expect(name).to.equal("");
    // expect(age).to.equal(0);
  });

  it("TEST", async function () {


    console.log("decimals", await zwjToken.decimals());
    console.log("totalSupply", await zwjToken.totalSupply());
    console.log("balanceOf", await zwjToken.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"));
    console.log(formatEther(await zwjToken.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));

    // expect(name).deep.equal("ZWJ");

  });

  it("transfer转账", async function () {

    // 转账方式1
    await zwjToken.transfer("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199", parseEther("1.0"), {
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    })
    // 转账方式2
    await zwjToken.connect(owner).transfer("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199", parseEther("1.0"));
    console.log("转账后");

    console.log("账号1", formatEther(await zwjToken.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));
    console.log("账号2", formatEther(await zwjToken.balanceOf("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199")));


    // expect(name).deep.equal("ZWJ");

  });



  it("depositEther存储ETH", async function () {


    await exChange.depositEther({
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      value: parseEther("10")
    })

    await exChange.depositEther({
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      value: parseEther("10")
    })



    console.log("depositEther转账后", formatEther(await exChange.tokens("0x0000000000000000000000000000000000000000", "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));


  });


  it("授权并，传入其他币", async function () {



    console.log(await exChange.getAddress());
    // 账户1希望交易exchange合约1000币
    await zwjToken.approve(await exChange.getAddress(), parseEther("1000"), {
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    })

    console.log("希望交易所allowance交易所里面", formatEther(await zwjToken.allowance("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", exChange.getAddress())));


    // 用户1存入exchange交易所1000代币，把zwjToken合约中的代币转移到exchange合约
    // 总的来说是zwjToken代币转移到了exchange里面
    // 本质上还是转移zwjToken代币到别的地方
    await exChange.depositToken(zwjToken.getAddress(), parseEther("1000"), {
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    })

    console.log("exChange交易所里面", formatEther(await exChange.tokens(zwjToken.getAddress(), "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")));



    //     await exChange.depositToken({
    //       from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    //       value: parseEther("10")
    //     })




  });





});
