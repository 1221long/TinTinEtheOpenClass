// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OpApe is ERC721 {
    uint public MAX_APES = 10000;
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    // BYAC ipfs://QmZoYNiWwoLim45Y7jfnsU9yr78MZ4NCaafnbGx4HaV9HR/
    function _baseURI() internal pure override  returns (string memory) {
        return "ipfs://QmZoYNiWwoLim45Y7jfnsU9yr78MZ4NCaafnbGx4HaV9HR/";
    }

    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId is out of range.");
        _mint(to, tokenId);
    }
}

