// SPDX-License-Identifier: UNLICENSED
// SPDX许可证标识符：未授权
// SPDX (Software Package Data Exchange) 许可证标识符用于说明合约的许可证类型。
// 该指令将用于 Solidity 编译器来验证版本。
// EIP 20: ERC-20 代币标准（Token Standard）
pragma solidity ^0.8.0;

contract ZWJToken {
    string public name = "ZWJToken"; //代币名称
    string public symbol = "ZWJ"; //代币代号
    uint256 public decimals = 18; //代币位数
    uint256 public totalSupply; //代币总量
    mapping(address => uint256) public balanceOf; //代币用户对应额度

    /*
    {
    "zwj":{
      "exchange":"100",
      "NFT":"100"
      }
    }
    */
    mapping(address => mapping(address => uint256)) public allowance; //用户：批准的合约：被转走额度

    constructor() {
        totalSupply = 1000000 * (10 ** decimals);
        // 运行部署合约的账号，将会持有所有代币
        balanceOf[msg.sender] = totalSupply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // 向 _to 地址转移 _value 数量的代币，函数必须触发事件 Transfer 。
        // 如果调用方的帐户余额没有足够的令牌，则该函数需要抛出异常。
        // 注意 转移0个代币也是正常转移动作，同样需要触发 Transfer 事件

        // require(_to != address(0), "Invalid address");
        // require(_value <= balanceOf[msg.sender], "Insufficient balance");

        // balanceOf[msg.sender] -= _value;
        // balanceOf[_to] += _value;
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        // 向 _to 地址转移 _value 数量的代币，函数必须触发事件 Transfer 。
        // 如果调用方的帐户余额没有足够的令牌，则该函数需要抛出异常。
        // 注意 转移0个代币也是正常转移动作，同样需要触发 Transfer 事件

        require(_from != address(0), "Invalid address_from");
        require(_to != address(0), "Invalid address_to");
        require(_value <= balanceOf[_from], "Insufficient balance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    // 扣除允许交易用户交易地址货币，修改balanceOf代币数据库
    // transferFrom是合约调用的函数，此前必须approve允许合约地址转走当前代币
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // msg.sender交易所地址

        require(balanceOf[_from] >= _value, "from balance insufficient"); // 检查 _from 地址的余额是否足够
        require(
            allowance[_from][msg.sender] >= _value,
            "from balance insufficient"
        ); // 这个合约地址，是否被授权提取足够数量的代币

        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);

        return true;
    }

    //批准_spender合约可以代表用户转移一定数量的ZWJToken代币

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        require(_spender != address(0), "exchange address error");
        // msg.sender用户授权账号地址
        // _spender交易所地址，这里表示允许交易所转我钱

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}
