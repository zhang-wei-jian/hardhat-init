// SPDX-License-Identifier: UNLICENSED
// SPDX许可证标识符：未授权
// SPDX (Software Package Data Exchange) 许可证标识符用于说明合约的许可证类型。

pragma solidity ^0.8.0;

import "./ZWJToken.sol";

contract ExChange {
    address public feeAccount; //收费账户地址
    uint256 public feePercent; //费率
    mapping(address => mapping(address => uint256)) public tokens;
    /*
       {
    "合约地址":{
        "用户公钥":100
      },
    "合约地址":{
        "用户公钥":100
      },
    }

    */
    address constant ETHER = address(0);

    struct _Order {
        uint256 id; // 订单的唯一标识符
        address addr; // 订单发起人的地址
        address tokenGet; // 订单中获取的代币合约地址
        uint256 amountGet; // 订单中获取的代币数量
        address tokenGive; // 订单中给出的代币合约地址
        uint256 amountGive; // 订单中给出的代币数量
        uint256 timestamp; // 订单创建的时间戳
        // uint256 orderState;
    }

    mapping(uint256 => _Order) public orders;
    mapping(uint256 => bool) public orderCancel;
    mapping(uint256 => bool) public orderFill;
    uint256 public orderCount;

    event Deposit(address token, address addr, uint256 amount, uint balance);
    event WithDraw(address token, address addr, uint256 amount, uint balance);

    event order(
        uint256 id,
        address addr,
        address tokenTokenGet,
        uint256 amountAmount,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );

    event Cancel(
        uint256 id,
        address addr,
        address tokenTokenGet,
        uint256 amountAmount,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );
    event Trade(
        uint256 id,
        address addr,
        address tokenTokenGet,
        uint256 amountAmount,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );

    constructor(address _feeAccount, uint256 _feePercent) {
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    // 存以太币
    function depositEther() public payable {
        // payable函数会自动存入智能合约钱
        // msg.sender  发送交易的地址
        // msg.value 调用该函数时附带的以太币数量
        /*
 原生币（如以太币）与代币（如 ERC20 代币）通常需要统一处理和管理。然而，原生币并不像代币那样有合约地址，因此开发者通常会使用一个特殊的地址（例如 address(0)）来表示原生币。这种做法使得代码处理各种不同类型的资产时更加统一和简洁。
        */

        tokens[ETHER][msg.sender] += msg.value; //发送者的eth 存储记录

        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
    }

    // 存其他货币到交易所。用户钱包货币减去，放入到智能合约地址钱包。等于用户代币被交易所拿着
    // 交易所添加另一个智能合约代币对应用户的币=》放入其他币对应对应用户余额
    function depositToken(address _contract, uint256 _value) public {
        // msg.sender 当前调用该函数的用户地址
        // _contract 传入的代币合约地址（例如：ZWJToken 合约地址）
        // address(this) 当前 ExChange 合约的地址
        require(_contract != address(0));

        require(
            ZWJToken(_contract).transferFrom(msg.sender, address(this), _value)
        ); //ZWJToken(_contract)动态合约调用，使用_contract识别来调用对应合约上的transferFrom函数

        tokens[_contract][msg.sender] += _value; //发送者的eth 存储记录

        emit Deposit(
            _contract,
            msg.sender,
            _value,
            tokens[_contract][msg.sender]
        );
    }

    // 提取以太币
    function withdrawEther(uint256 _value) public {
        require(tokens[ETHER][msg.sender] >= _value);
        tokens[ETHER][msg.sender] -= _value;
        payable(msg.sender).transfer(_value);
        emit WithDraw(ETHER, msg.sender, _value, tokens[ETHER][msg.sender]);
    }

    // 提取其他代币
    function withdrawToken(address _contract, uint256 _value) public {
        require(_contract != ETHER);
        require(tokens[_contract][msg.sender] >= _value);

        tokens[_contract][msg.sender] -= _value;

        require(ZWJToken(_contract).transfer(msg.sender, _value));
        emit WithDraw(
            _contract,
            msg.sender,
            _value,
            tokens[_contract][msg.sender]
        );
    }

    // 查询 智能合约地址用户的货币余额
    // 合约代币地址，用户公钥
    function balanceOf(
        address _contract,
        address _addr
    ) public view returns (uint256) {
        return tokens[_contract][_addr];
    }

    // 创建订单
    function makeOrder(
        address _tokenGet,
        uint256 _amountGet,
        address _tokenGive,
        uint256 _amountGive
    ) public {
        // 检查传入的地址是否有效
        require(
            _tokenGet != address(0) || _tokenGet == ETHER,
            "Invalid _tokenGet address"
        );
        require(
            _tokenGive != address(0) || _tokenGive == ETHER,
            "Invalid _tokenGive address"
        );

        // 检查传入的金额是否有效
        require(_amountGet > 0, "Invalid _amountGet value");
        require(_amountGive > 0, "Invalid _amountGive value");

        orderCount += 1;

        orders[orderCount] = _Order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
        );

        emit order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
        );
    }

    // 取消订单
    function cancelOrder(uint256 _id) public {
        _Order memory myOrder = orders[_id];
        require(myOrder.id == _id);
        orderCancel[_id] = true;

        emit Cancel(
            myOrder.id,
            msg.sender,
            myOrder.tokenGet,
            myOrder.amountGet,
            myOrder.tokenGive,
            myOrder.amountGive,
            block.timestamp
        );
    }

    // 交易订单
    function fillOrder(uint256 _id) public {
        // // msg.sender 购买人调用者
        // _Order memory myOrder = orders[_id];
        // require(myOrder.id == _id);
        // orderFill[_id] = true;

        // // address addr; // 订单发起人的地址
        // // address tokenGet; // 获取的代币合约地址
        // // uint256 amountGet; // 获取的代币数量
        // // address tokenGive; // 给出的代币合约地址
        // // uint256 amountGive; // 给出的代币数量
        // // uint256 timestamp; // 订单创建的时间戳

        // //  订单创建人 收到代币，扣除交易人代币
        // tokens[myOrder.tokenGet][msg.sender] -= myOrder.amountGet;
        // tokens[myOrder.tokenGet][myOrder.addr] += myOrder.amountGet;

        // //  交易订单人 拿到代币，扣除创建订单人代币
        // tokens[myOrder.tokenGive][msg.sender] += myOrder.amountGive;
        // tokens[myOrder.tokenGive][myOrder.addr] -= myOrder.amountGive;

        _Order memory myOrder = orders[_id];
        require(myOrder.id == _id, "Order ID does not match");
        require(!orderFill[_id], "Order already filled");

        // 检查余额是否足够
        require(
            tokens[myOrder.tokenGet][msg.sender] >= myOrder.amountGet,
            "Insufficient balance for tokenGet"
        );
        require(
            tokens[myOrder.tokenGive][myOrder.addr] >= myOrder.amountGive,
            "Insufficient balance for tokenGive"
        );

        orderFill[_id] = true;

        // 订单创建人 收到代币，扣除交易人代币
        tokens[myOrder.tokenGet][msg.sender] -= myOrder.amountGet;
        tokens[myOrder.tokenGet][myOrder.addr] += myOrder.amountGet;

        // 交易订单人 拿到代币，扣除创建订单人代币
        tokens[myOrder.tokenGive][msg.sender] += myOrder.amountGive;
        tokens[myOrder.tokenGive][myOrder.addr] -= myOrder.amountGive;

        // 小费,交易人需要多扣除小费给交易所账号
        // uint256 feeAmountGet = (myOrder.amountGet * feePercent) / 100;
        // uint256 feeAmountGive = (myOrder.amountGive * feePercent) / 100;
        // tokens[myOrder.tokenGive][feeAccount] += feeAmountGive;

        emit Trade(
            myOrder.id,
            myOrder.addr,
            myOrder.tokenGet,
            myOrder.amountGet,
            myOrder.tokenGive,
            myOrder.amountGive,
            block.timestamp
        );
    }
}
