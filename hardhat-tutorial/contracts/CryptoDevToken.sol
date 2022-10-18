//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICryptoDevs.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CryptoDevToken is ERC20, Ownable {

    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant maxTokenSupply = 10000 * 10**18;

    ICryptoDevs CryptoDevsNFT;

    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsNFTContract) ERC20("CryptoDevToken", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsNFTContract);
    }

    function mint(uint256 _amount) public payable {
        uint256 requiredAmount = tokenPrice * _amount;
        require(msg.value >= requiredAmount, "Ether sent is not enough!");
        uint256 amountWithDecimals = _amount * 10**18;
        require((totalSupply() + amountWithDecimals) <= maxTokenSupply, "Cannot mint beyond the max limit!");
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;

        uint256 balance = CryptoDevsNFT.balanceOf(sender);

        require(balance > 0, "You dont have an NFT!");

        uint256 amount  = 0;

        for(uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if(!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all the tokens!");

        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Withdraw failed!");
    }

    receive() external payable{}

    fallback() external payable{}

}