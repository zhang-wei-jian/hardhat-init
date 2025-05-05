// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract bank {
    mapping(address => uint256) public balances; //记录函数存款的人和余额
    address public owner; //部署人

    // 初始化设定合约部署人控制
    constructor() {
        owner = msg.sender;
    }

// 自定义修饰符
    modifier only_owner() {
        require(msg.sender == owner);
        _;
    }

    // 合约接收到eth回调函数
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    // 存款
    function deposit() public payable {
        // msg.value 是用户发来的 ETH 金额
        balances[msg.sender] += msg.value;
    }

    // 提款机
    function withdraw(uint256 amount) public  only_owner {
        // require(this.balances>= amount, "balance is not insufficient!");
        require(
            address(this).balance >= amount,
            "balance is  insufficient!"
        );
        // payable(msg.sender).transfer(amount);
        payable(owner).transfer(amount);
    }
}

// 可以接受eth直接发送eth给合约地址，还是通过despoit函数调用
// 相当于众筹，最后记录了存储人，所有人可以把钱拿走
