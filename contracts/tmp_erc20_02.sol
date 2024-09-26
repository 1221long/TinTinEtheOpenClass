// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TWO20 is ERC20 {

    constructor() ERC20("TWO20","TWO20"){

    }

    function mint(uint amount) external {
        _mint(msg.sender, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
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