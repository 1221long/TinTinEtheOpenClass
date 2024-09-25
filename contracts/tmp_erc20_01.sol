// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ONE20 is ERC20 {

    mapping(address => uint256) public balances;

    uint256 public totalSupplys;

    constructor() ERC20("ONE20","ONE20"){

    }    

    function mint(uint amount) external {
        balances[msg.sender] += amount;
        totalSupplys += amount;
        emit Transfer(address(this), msg.sender, amount);
    }

    function burn(uint amount) external {
        balances[msg.sender] -= amount;
        totalSupplys -= amount;
        emit Transfer(msg.sender, address(this), amount);
    }

    // // contract 
    // fallback() external payable {
    //     deposit();
    // }

    // // contract receive ETH, will invoke this function
    // receive() external payable {
    //     deposit();
    // }

    // // deposit
    // function deposit() public payable {
    //     _mint(msg.sender, msg.value);
    //     emit Deposit(msg.sender, msg.value);
    // }

    // function withdraw(uint amount) public payable {
    //     require(balanceOf(msg.sender) >= amount);
    //     _burn(msg.sender, amount);
    //     payable(msg.sender).transfer(amount);
    //     emit Withdraw(msg.sender, amount);
    // }
}