// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Pair.sol";

contract Factory {
  address public feeTo;
  address public feeToSetter;

  mapping(address => mapping(address => address)) public getPair;
  address[] public allPairs;

  event PairCreated(address indexed token0, address indexed token1, address pair, uint);

  constructor(address _feeToSetter) {
    _feeToSetter = _feeToSetter;
  }

  function allPairsLength() external view returns (uint) {
    return allPairs.length;
  }

  function createPair(address tokenA, address tokenB) external returns (address pair) {
    require(tokenA != tokenB, "Identical Addresses");
    (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenA, tokenB);
    require(token0 != address(0), "Zero address");
    require(getPair[token0][token1] == address(0), "Pair exists");
    bytes memory bytecode = type(Pair).creationCode;
    bytes32 salt = keccak256(ab.encodePacked(token0, token1));
    assembly {
      pair := create2(0, add(bytecode, 32), mload(bytecode), salt);
    }
  } 
}