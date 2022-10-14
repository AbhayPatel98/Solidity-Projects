// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Abhay is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public miniRate = 0.01 ether; //minimun rate of minting NFT is 0.01eth
    uint public max_mint = 2; //Maximun minting is 2.(totalsupply)

    constructor() ERC721("Abhay", "AP") {}

    function safeMint(address to) public payable {
        require(totalSupply() < max_mint, "can not mint more than 2");
        require(msg.value>= miniRate, "not enough ETH sent!");
        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current());
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal
        override(ERC721, ERC721Enumerable)
    {
       
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
       
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
     require(address(this).balance > 0, "balance is 0");
     payable(owner()).transfer(address(this).balance);

    }
}