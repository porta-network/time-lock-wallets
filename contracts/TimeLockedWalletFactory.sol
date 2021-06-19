// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./TimeLockedWallet.sol";
import "./Ownable.sol";

contract TimeLockedWalletFactory is Ownable {
 
    address[] private wallets;
    mapping(address => string) private walletNames;

    function getWallets() public view returns(address[] memory) {
        return wallets;
    }
    
    function searchWallet(address _wallet) public view returns(string memory) {
        return walletNames[_wallet];
    }

    function createTimeLockedWallet(
        string memory walletName,
        address _owner, 
        uint256 _unlockDate
    ) payable public onlyOwner returns(address wallet) {
        // Create new wallet.
        TimeLockedWallet newWallet = new TimeLockedWallet(msg.sender, _unlockDate);

        wallet = address(newWallet);

        // Add wallet to sender's wallets.
        wallets.push(wallet);

        walletNames[wallet] = walletName;

        // Emit event.
        emit Created(wallet, msg.sender, _owner, block.timestamp, _unlockDate, msg.value);
    }

    // Prevents accidental sending of ether to the factory
    fallback () external {
        revert();
    }

    event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
}
