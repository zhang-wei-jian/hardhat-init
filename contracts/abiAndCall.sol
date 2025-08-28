// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractA {
    uint public a;

    constructor() {
        a = 1;
    }
    //0xee919d50000000000000000000000000000000000000000000000000000000000000022b
    function setA(uint _a) public {
        a = _a;
    }
}

contract ContractB {
    uint public a;
    uint public b;
    bytes public callMethodDataHash;

    constructor() {
        a = 222;
        b = 1;
    }
    function setB(uint _b) public {
        b = _b;
    }

    // 普通调用函数
    function method(address addr, uint count) public {
        ContractA(addr).setA(count);
    }

    // call调用函数
    //这个函数inpu的哈希 0x9e1a324400000000000000000000000086ba8f41279c2b029ee140698d09c0766a71419f0000000000000000000000000000000000000000000000000000000000001102
    function callMethod(address addr, uint count) public {
        bytes memory callMethodData = abi.encodeWithSignature(
            "setA(uint256)",
            count
        );
        callMethodDataHash = callMethodData;
        (bool success, ) = addr.call(callMethodData);

        require(success, "call Error");
    }
}
