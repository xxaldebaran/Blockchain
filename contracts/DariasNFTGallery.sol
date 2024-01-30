// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Creating a contract for the ERC721 token
contract DariasNFTGallery is ERC721 {
    uint256 public maxSupply;
    uint256 public totalSupply;
    address public owner;

// Defining properties for each NFT item 
    struct Item {
        string name;
        uint256 cost;
        string image;
        bool isOwned;
    }

// Mapping the item id to the item properties
    mapping(uint256 => Item) items;

// Restricting access to the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

// Initialising NFT token 
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

// Function allowing the contract owner to list a new NFT item
    function list(
        string memory _name,
        uint256 _cost,
        string memory _image
    ) public onlyOwner {
        // Incrementing the max supply and adding the new item to the items mapping
        maxSupply++;
        items[maxSupply] = Item(_name, _cost, _image, false);
    }

// Minting NFT by a user by providing the NFT ID and paying the specified cost
    function mint(uint256 _id) public payable {
        require(_id != 0);
        require(_id <= maxSupply);
        require(items[_id].isOwned == false);
        require(msg.value >= items[_id].cost);

        items[_id].isOwned = true;
        totalSupply++;

        // Mint NFT to the user ID
        _safeMint(msg.sender, _id);
    }

// Getting the details of a specific NFT by its ID
    function getItem(uint256 _id) public view returns (Item memory) {
        return items[_id];
    }

// Getting the contract's current balance 
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

// Function allowing the contract owner to withdraw the contract's Ether balance
    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}
