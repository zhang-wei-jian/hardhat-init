
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.0;

import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


interface INftmarket {
    function tokensReceived(address operator,uint amount,bytes calldata data ) external  ;
}

contract ZwjToken is ERC20, ERC1363, ERC20Permit, Ownable {

  

    constructor(address recipient, address initialOwner)
        ERC20("ZwjToken", "ZWJ")
        ERC20Permit("ZwjToken")
        Ownable(initialOwner)
    {
        _mint(recipient, 1000000 * 10 ** decimals());
    }

    function safeMint(address recipient,uint value ) public onlyOwner {
       _mint(recipient,  value* 10 ** decimals());
    }

    // 转账 并且触发回调函数
    function transferWithCallback(address to  , uint amount ,bytes calldata data) public {
        // _transfer(msg.sender,to,amount);
        _approve(msg.sender,to,amount);
        
        if(to.code.length>0){
            INftmarket(to).tokensReceived(msg.sender,amount,data);
        }
    }
}