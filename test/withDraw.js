



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
    exChange = await ExChange.deploy("0x14dC79964da2C08b23698B3D3cc7Ca32193d9955", 10);


    [owner, addr1, addr2] = await ethers.getSigners();
  });





  it("查询zwj合约", async function () {


    const network = await ethers.provider.getNetwork();
    console.log("Connected to network:", network.name);
    console.log("查询zwj合约", formatEther(await zwjToken.balanceOf("0x14dC79964da2C08b23698B3D3cc7Ca32193d9955")));



    console.log("Network chain ID:", network.chainId);

    // 获取 RPC URL
    const provider = ethers.provider;
    const providerUrl = provider.connection?.url || "unknown";
    console.log("Connected to RPC URL:", providerUrl);




  });

  it("depositEther存储ETH", async function () {


    await exChange.depositEther({
      from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
      value: parseEther("10")
    })

    await exChange.depositEther({
      from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
      value: parseEther("10")
    })



    console.log("depositEther转账后", formatEther(await exChange.tokens("0x0000000000000000000000000000000000000000", "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955")));


  });


  it("授权并，传入其他币", async function () {



    console.log(await exChange.getAddress());
    // 账户1希望交易exchange合约1000币
    await zwjToken.approve(await exChange.getAddress(), parseEther("1000"), {
      from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    })

    console.log("希望交易所allowance交易所里面", formatEther(await zwjToken.allowance("0x14dC79964da2C08b23698B3D3cc7Ca32193d9955", exChange.getAddress())));


    // 用户1存入exchange交易所1000代币，把zwjToken合约中的代币转移到exchange合约
    // 总的来说是zwjToken代币转移到了exchange里面
    // 本质上还是转移zwjToken代币到别的地方
    await exChange.depositToken(zwjToken.getAddress(), parseEther("1000"), {
      from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    })

    console.log("exChange交易所里面", formatEther(await exChange.tokens(zwjToken.getAddress(), "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955")));



    //     await exChange.depositToken({
    //       from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    //       value: parseEther("10")
    //     })




  });



  it("提取币", async function () {


    const exChangeAddress = await exChange.getAddress()


    // 用户1（owner.address）允许交易所合约（exChangeAddress）在需要时能够代表他转移最多1000个ZWJToken。这并不意味着用户1正在交易这些代币，而是设置了一个允许限额（allowance）。
    await zwjToken.approve(exChangeAddress, parseEther("1000"), {
      from: owner.address,
    })
    // 查询 我允许交易的币 还有多少
    const oneAccpunt = await zwjToken.allowance(owner, await exChangeAddress)
    console.log("oneAccpunt", formatEther(oneAccpunt));





    /*

    放到交易所代币 
    地址：为了识别代币类型和交易所对应合约的用户有多少钱
    然后我使用exchange函数调用传入zwj合约地址表示我要拿zwj代币存入到这个exchange交易所，内部执行会把zwj智能合约的币扣掉放到exchange智能合约交易所地址上，然后在exchange交易所变量上添加zwj合约地址对应我的代币
    */
    await exChange.depositToken(zwjToken.getAddress(), parseEther("400"), {
      from: owner.address,
    })


    console.log("exChange交易所里面zwj代币地址对应我余额", formatEther(await exChange.tokens(zwjToken.getAddress(), owner.address)));


    // await exChange.depositToken(zwjToken.getAddress(), parseEther("500"), {
    //   from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    // })

    // console.log("exChange交易所里面", formatEther(await exChange.tokens(zwjToken.getAddress(), "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955")));





    // // 提取exchange的Eth
    // const res1 = await exChange.withdrawEther(parseEther("10"), {
    //   from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    // })


    // console.log("exChange交易所里面", formatEther(await exChange.tokens("0x0000000000000000000000000000000000000000", zwjToken.getAddress(), "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955")));


    // await exChange.withdrawToken(zwjToken.getAddress(), parseEther("50000"))

    // console.log(res1);




    //     await exChange.depositToken({
    //       from: "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955",
    //       value: parseEther("10")
    //     })




  });


  it("创建订单", async function () {
    const exChangeAddress = await exChange.getAddress()
    const zwjTokenAddress = await zwjToken.getAddress()



    // 定义过滤器
    const filter = exChange.filters.order();

    // 查询日志
    const logs = await exChange.queryFilter(filter);

    // 解析日志
    const parsedLogs = logs.map(log => exChange.interface.parseLog(log));

    // 输出结果
    console.log("创建的订单:", parsedLogs);


    await exChange.makeOrder(zwjTokenAddress, parseEther("1000"), zwjTokenAddress, parseEther("1000"), {
      from: owner.address,
    })



    // const logs = await exChange.queryFilter(filter);//使用合约实例的 queryFilter 方法来获取符合过滤器条件的事件日志。

    // const parsedLogs = logs.map(log => exChange.interface.parseLog(log));
    // console.log("创建的订单!!!!!!!!!!!!!!!", parsedLogs);


    // 定义过滤器
    const filter2 = exChange.filters.order();

    // 查询日志
    const logs2 = await exChange.queryFilter(filter2);

    // 解析日志
    const parsedLogs2 = logs2.map(log => exChange.interface.parseLog(log));

    // 输出结果
    // console.log("创建的订单:", parsedLogs2);


  });





});
