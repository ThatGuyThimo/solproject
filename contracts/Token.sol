// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

import "../interfaces/IERC20.sol";
import "../math/Math.sol";



contract Token is IERC20 {
    // String identifyers.
    string private _name = "MyToken";
    string private _symbol = "MTN";

    // Total token supply.
    uint256 private _totalSupply = 1000000;
    uint8 private _decimals = 18;
    // Owner Address.
    address public _owner;

    bool private fromPassed = false;
    bool private toPassed = false;

    // A mapping to store each account's balance.
    mapping(address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    /**
     * constructor init.
     */
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the account that is deploying the contract.
        _balances[msg.sender] = _totalSupply;
        _owner = msg.sender;
        _decimals = 18;
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    function totalSupply() public view returns(uint256) {
        return _totalSupply;
    }

     /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        // Notify offchain applications of the Approval.
        emit Approval(owner, spender, amount);

    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);

        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside* the contract.
     */
    function transfer(address to, uint256 amount) external returns(bool){
        // Check if the transaction sender has enough tokens.
        // If the `require's` first argument resolves to false then the transaction will be reverted.
        require(_balances[msg.sender] >= amount, "insufficient tokens");

        require(msg.sender != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        //transfer the amount.
        (fromPassed, _balances[msg.sender]) = Math.trySub(_balances[msg.sender], amount);
        (toPassed, _balances[to]) = Math.tryAdd(_balances[to], amount);

        require(fromPassed == true);
        require(toPassed == true);

        // Notify offchain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * A function to transfer tokens from an address to an address.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        // Check if the transaction sender has enough tokens.
        // If the `require's` first argument resolves to false then the transaction will be reverted.
        require(_balances[from] >= amount, "insufficient tokens");

        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        //transfer the amount.
        (fromPassed, _balances[from]) = Math.trySub(_balances[from], amount);
        (toPassed, _balances[to]) = Math.tryAdd(_balances[to], amount);

        require(fromPassed == true);
        require(toPassed == true);

        // Notify offchain applications of the transfer.
        emit Transfer(from, to, amount);
        return true;
    }


    /**
     * Read only function to retrieve the token balance of a given account.
     * The `view` modifier indicates that it doesn't modify the contract's state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
}