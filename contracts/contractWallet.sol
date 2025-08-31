// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract Wallet {
    address public owner;


    event Deposit(address indexed sender, uint256 amount, uint256 balance);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not owner");
        _;
    }

    receive() external payable {
      
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function walletTransfer(
        address _addr,
        uint256 _value,
        bytes calldata _data
    ) public onlyOwner {
        (bool success, ) = _addr.call{value: _value}(_data);
        require(success, "Transfer Failed");
    }


    //     function deposit() public payable {
    //     balance[msg.sender] += msg.value;
    //     emit Deposit(msg.sender, msg.value, balance[msg.sender]);
    // }

    // function withdraw(address _addr, uint256 _value) public onlyOwner {
    //     (bool success, ) = _addr.call{value: _value}("");
    //     balance[msg.sender] -= _value;
    //     require(success, "Transfer Failed");
    // }
}
