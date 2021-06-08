// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract TimeLockedWallet {

    address public creator;
    address public owner;
    uint256 public unlockDate;
    uint256 public createdAt;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner, uint256 _unlockDate) {
        owner = _owner;
        unlockDate = _unlockDate;
        createdAt = block.timestamp;
    }

    // keep all the ether sent to this address
    fallback () payable external { 
        emit Received(msg.sender, msg.value);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // callable by owner only, after specified time
    function withdraw() onlyOwner public {
       require(block.timestamp >= unlockDate);
       //now send all the balance
       payable(msg.sender).transfer(address(this).balance);
       emit Withdrew(msg.sender, address(this).balance);
    }

    // callable by owner only, after specified time, only for Tokens implementing IERC20
    function withdrawTokens(address _tokenContract) onlyOwner public {
       require(block.timestamp >= unlockDate);
       IERC20 token = IERC20(_tokenContract);
       //now send all the token balance
       uint256 tokenBalance = token.balanceOf(address(this));
       token.transfer(owner, tokenBalance);
       emit WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
    }

    function info() public view returns(address, uint256, uint256, uint256) {
        return (owner, unlockDate, createdAt, address(this).balance);
    }

    event Received(address from, uint256 amount);
    event Withdrew(address to, uint256 amount);
    event WithdrewTokens(address tokenContract, address to, uint256 amount);
}
