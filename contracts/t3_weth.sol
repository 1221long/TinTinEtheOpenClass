// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
存款：包装，用户将ETH存入WETH合约，并获得等量的WETH。
取款：拆包装，用户销毁WETH，并获得等量的ETH。
*/
// contract address: 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
// person address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

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

/*
-- LOG 1
status	0x1 Transaction mined and execution succeed
transaction hash	0x3f6715125f883f5a062e30eed783872d74cd380635d5677c4cf6db5ec239bd5a
block hash	0x6c436629bb652ca38b6ddcc6098e7a974b1c5240bb90f9df3203d13389814a1f
block number	10
from	0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
to	WETH.deposit() 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
gas	79932 gas
transaction cost	69506 gas 
execution cost	48442 gas 
input	0xd0e...30db0
output	0x
decoded input	{}
decoded output	{}
logs	[
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
		"event": "Transfer",
		"args": {
			"0": "0x0000000000000000000000000000000000000000",
			"1": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"2": "1000000000000000000",
			"from": "0x0000000000000000000000000000000000000000",
			"to": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"value": "1000000000000000000"
		}
	},
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c",
		"event": "Deposit",
		"args": {
			"0": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"1": "1000000000000000000",
			"dst": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"wad": "1000000000000000000"
		}
	}
]
raw logs	[
  {
    "logIndex": "0x1",
    "blockNumber": "0xa",
    "blockHash": "0x6c436629bb652ca38b6ddcc6098e7a974b1c5240bb90f9df3203d13389814a1f",
    "transactionHash": "0x3f6715125f883f5a062e30eed783872d74cd380635d5677c4cf6db5ec239bd5a",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x0000000000000000000000000000000000000000000000000de0b6b3a7640000",
    "topics": [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4"
    ]
  },
  {
    "logIndex": "0x1",
    "blockNumber": "0xa",
    "blockHash": "0x6c436629bb652ca38b6ddcc6098e7a974b1c5240bb90f9df3203d13389814a1f",
    "transactionHash": "0x3f6715125f883f5a062e30eed783872d74cd380635d5677c4cf6db5ec239bd5a",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x0000000000000000000000000000000000000000000000000de0b6b3a7640000",
    "topics": [
      "0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4"
    ]
  }
]
value	1000000000000000000 wei

-- LOG 2

status	0x1 Transaction mined and execution succeed
transaction hash	0x53e19f744535a222f57a4de5ee4ebc61d47817b60dd5d47210f4239e99db96e7
block hash	0xcb599ace25aab35b6ae8f402e38aac7b152dfc2dca938ffbe0f4a5b53c78dc86
block number	11
from	0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
to	WETH.(receive) 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
gas	40382 gas
transaction cost	35114 gas 
execution cost	14114 gas 
input	0x
output	0x
decoded input	-
decoded output	 - 
logs	[
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
		"event": "Transfer",
		"args": {
			"0": "0x0000000000000000000000000000000000000000",
			"1": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"2": "1000000000000000000",
			"from": "0x0000000000000000000000000000000000000000",
			"to": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"value": "1000000000000000000"
		}
	},
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c",
		"event": "Deposit",
		"args": {
			"0": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"1": "1000000000000000000",
			"dst": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"wad": "1000000000000000000"
		}
	}
]
raw logs	[
  {
    "logIndex": "0x1",
    "blockNumber": "0xb",
    "blockHash": "0xcb599ace25aab35b6ae8f402e38aac7b152dfc2dca938ffbe0f4a5b53c78dc86",
    "transactionHash": "0x53e19f744535a222f57a4de5ee4ebc61d47817b60dd5d47210f4239e99db96e7",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x0000000000000000000000000000000000000000000000000de0b6b3a7640000",
    "topics": [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4"
    ]
  },
  {
    "logIndex": "0x1",
    "blockNumber": "0xb",
    "blockHash": "0xcb599ace25aab35b6ae8f402e38aac7b152dfc2dca938ffbe0f4a5b53c78dc86",
    "transactionHash": "0x53e19f744535a222f57a4de5ee4ebc61d47817b60dd5d47210f4239e99db96e7",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x0000000000000000000000000000000000000000000000000de0b6b3a7640000",
    "topics": [
      "0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4"
    ]
  }
]
value	1000000000000000000 wei

-- LOG 3


status	0x1 Transaction mined and execution succeed
transaction hash	0xe7e93d881826d547c2c03dc6e5c10b5c66d5e962b3a51690601b9d7686619fb4
block hash	0x6e95bd658bad6406e0c0dc409d2d52cf1db5c4d405cc473ed800bd646c605b73
block number	12
from	0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
to	WETH.withdraw(uint256) 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
gas	49288 gas
transaction cost	42859 gas 
execution cost	21595 gas 
input	0x2e1...60000
output	0x
decoded input	{
	"uint256 amount": "1500000000000000000"
}
decoded output	{}
logs	[
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
		"event": "Transfer",
		"args": {
			"0": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"1": "0x0000000000000000000000000000000000000000",
			"2": "1500000000000000000",
			"from": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"to": "0x0000000000000000000000000000000000000000",
			"value": "1500000000000000000"
		}
	},
	{
		"from": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
		"topic": "0x884edad9ce6fa2440d8a54cc123490eb96d2768479d49ff9c7366125a9424364",
		"event": "Withdraw",
		"args": {
			"0": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"1": "1500000000000000000",
			"src": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"wad": "1500000000000000000"
		}
	}
]
raw logs	[
  {
    "logIndex": "0x1",
    "blockNumber": "0xc",
    "blockHash": "0x6e95bd658bad6406e0c0dc409d2d52cf1db5c4d405cc473ed800bd646c605b73",
    "transactionHash": "0xe7e93d881826d547c2c03dc6e5c10b5c66d5e962b3a51690601b9d7686619fb4",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x00000000000000000000000000000000000000000000000014d1120d7b160000",
    "topics": [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4",
      "0x0000000000000000000000000000000000000000000000000000000000000000"
    ]
  },
  {
    "logIndex": "0x1",
    "blockNumber": "0xc",
    "blockHash": "0x6e95bd658bad6406e0c0dc409d2d52cf1db5c4d405cc473ed800bd646c605b73",
    "transactionHash": "0xe7e93d881826d547c2c03dc6e5c10b5c66d5e962b3a51690601b9d7686619fb4",
    "transactionIndex": "0x0",
    "address": "0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005",
    "data": "0x00000000000000000000000000000000000000000000000014d1120d7b160000",
    "topics": [
      "0x884edad9ce6fa2440d8a54cc123490eb96d2768479d49ff9c7366125a9424364",
      "0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4"
    ]
  }
]


*/