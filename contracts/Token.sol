// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Token {
    // String identifyers.
    string public name = "MyToken";
    string public symbol = "MT";

    // Total token supply.
    uint256 public totalSupply = 1000000;

    // Owner Address.
    address public owner;

    // A mapping to store each account's balance.
    mapping(address => uint256) balances;

    // Transfer event to help offchain apps to understand what happens whithin the application.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * constructor init.
     */

    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the account that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside* the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If the `require's` first argument resolves to false then the transaction will be reverted.
        require(balances[msg.sender] >= amount, "insufficient tokens");

        //transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify offchain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     * The `view` modifier indicates that it doesn't modify the contract's state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}