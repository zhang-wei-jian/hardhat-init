// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractA {

      function callContract(address _addr) public {
       Fishing(_addr).delegateCallMethod();//他调用之后msg.sender是谁
    }

}

contract Fishing {
    //用到delegatecall执行当前上下文，一定要注意保持变量顺序一致性
    address public msgSender;
    address public hackerAddress;//黑客合约地址
    

    constructor(address _hackContract) {
       hackerAddress = _hackContract;
    }

    // delegateCall调用，注意调用的函数会写在当前合约
    function delegateCallMethod() public {
        bytes memory callMethodData = abi.encodeWithSignature(
            "hackerFunc()"
        );

        (bool success, ) = hackerAddress.delegatecall(callMethodData);
        require(success, "delegateCall Error");
    }
}


contract HackerMalice {

    address public msgSender;

    // function getmsgSender() public view returns(address) {
    //   return msgSender;
    // }
    function setmsgSender() public   {
       msgSender = 0x6666000000000000000000000000000000000000;
    }

    // 黑客恶意代码
    function hackerFunc() public {

    msgSender=msg.sender;
    
    }

}

//总结：
//1. delegatecall 相当于把调用合约的函数执行在当前上下文，如果涉及到修改变量一定要注意顺序定义一致性
//2. delegatecall 的msg.sender指向的是使用delegatecall当前上下文的msg.sender调用者保持msg.sender不变，而不是穿透到最原始调用者

//delegatecall  能实现黑客攻击，只要有人调用了钓鱼合约，那么就能拿到msg.sender调用人权限（如果是eoa可以转走代币，如果是合约账户可以转走eth）
