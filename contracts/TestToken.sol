// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StandardToken.sol";

contract TestToken is StandardToken {
    string public name = "TestToken";
    string public symbol = "TEST";
    uint public decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function issueCoins(address receipient, uint amount) public {
        _mint(receipient, amount);
    }

    function quickIssueCoin(address receipient) public {
        if(balanceOf(receipient) == 0) {
            _mint(receipient, 1 * 1e18); //1 tokens
        }
    }
}