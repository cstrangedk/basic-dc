pragma solidity ^0.4.21;

import '../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

/**
  @title Basic_DC, a prototype

  Prototyping implementation of ERC721
  Uses OpenZeppelin ERC721Token
 */

contract Basic_DC is ERC721Token, Ownable {
  string public constant NAME = "GruvyLu";
  string public constant SYMBOL = "GLU";

  uint256 public constant PRICE = .001 ether;

  mapping(uint256 => uint256) tokenToPriceMap;

  function Basic_DC() public {

  }

  function name() public view returns(string) {
    return NAME;
  }

  function symbol() public view returns(string) {
    return SYMBOL;
  }

  function mint(uint256 colorId) public payable {
    require(msg.value >= PRICE);
    _mint(msg.sender, colorId);
    tokenToPriceMap[colorId] = PRICE;

    if (msg.value > PRICE) {
      uint256 priceExcess = msg.value - PRICE;
      msg.sender.transfer(priceExcess);
    }
  }

  function claim(uint256 colorId) public payable onlyMintedTokens(colorId) {
    uint256 askingPrice = getClaimingPrice(colorId);
    require(msg.value >= askingPrice);
    safeTransferFrom(ownerOf(colorId), msg.sender, colorId);
    tokenToPriceMap[colorId] = askingPrice;
  }

  function getClaimingPrice(uint256 colorId) public view onlyMintedTokens(colorId) returns(uint256) {
    uint256 currentPrice = tokenToPriceMap[colorId];
    uint256 askingPrice = (currentPrice * 50) / 100;
    return askingPrice;
  }

  modifier onlyMintedTokens(uint256 colorId) {
    require (tokenToPriceMap[colorId] != 0);
    _;
  }
}
