// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
存款：包装，用户将ETH存入WETH合约，并获得等量的WETH。
取款：拆包装，用户销毁WETH，并获得等量的ETH。
*/

// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {

    // 存款
    event Deposit(address indexed dst, uint wad);
    // 取款
    event Withdraw(address indexed src, uint wad);

    constructor() ERC20("WETH","WETH"){

    }

    // contract 
    fallback() external payable {
        deposit();
    }

    // contract receive ETH, will invoke this function
    receive() external payable {
        deposit();
    }

    // deposit
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public payable {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
}