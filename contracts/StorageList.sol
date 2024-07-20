// SPDX-License-Identifier: UNLICENSED
// SPDX许可证标识符：未授权
// SPDX (Software Package Data Exchange) 许可证标识符用于说明合约的许可证类型。
// "UNLICENSED" 表示此合约未附带任何许可证。

// Solidity 文件必须以这个 pragma 开头。
// 该指令将用于 Solidity 编译器来验证版本。
pragma solidity ^0.8.0;



contract StorageList {
  //  默认storage 状态，链上数据

  struct user {
    uint id;
    string name;
    uint age;
  }

  user[] public userList;

// 默认storage。形参，都不上链。  memory可修改。 calldata 不修改
  function addList(string calldata _name,uint _age) public{
   uint  length = userList.length+1;
   uint  id = length;
    userList.push(user(id,_name,_age));
  }

// 函数类型声明：节省燃料。view 读取链上数据，不修改,pure 纯函数
   function getList() public view returns ( user[] memory ){

    return (userList);
    
  }
 
}
