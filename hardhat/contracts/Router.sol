// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Factory.sol";

contract Router {
  Factory public factory;
  
  constructor(address _factory) {
    factory = Factory(_factory);
  }

  function _addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin
  ) internal returns (uint256 amountA, uint256 amountB)
  {
    if (factory.getPair(tokenA, tokenB) == address(0)) {
      factory.createPair(tokenA, tokenB);
    }
  }

  function _swap(uint256[] memory amounts, address[] memory path, address _to) internal {
    for (uint256 i; i < path.length - 1; i ++) {
      (address input, address output) = (path[i], path[i + 1]);
      (address token0, ) = 
    }
  }
}