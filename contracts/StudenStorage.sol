// SPDX-License-Identifier: UNLICENSED
// SPDX许可证标识符：未授权
// SPDX (Software Package Data Exchange) 许可证标识符用于说明合约的许可证类型。
// "UNLICENSED" 表示此合约未附带任何许可证。

// Solidity 文件必须以这个 pragma 开头。
// 该指令将用于 Solidity 编译器来验证版本。
pragma solidity ^0.8.0;

// import "hardhat/console.sol";

contract StudenStorage {
  //  默认storage 状态，链上数据
  uint public age = 0;
  string public name = "";

// 默认storage。形参，都不上链。  memory可修改。 calldata 不修改
  function setData(string calldata _name,uint _age) public{
    // 写上memory不上链 节省性能 
    // string memory a
    name = _name;
    age= _age;
    
  }

// 函数类型声明：节省燃料。view 读取链上数据，不修改,pure 纯函数
   function getData() public view returns (string memory ,uint ){

    return (name,age);
    
  }
 
}
