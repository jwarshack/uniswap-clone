// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib/Math.sol";

interface IERC20 {
  function balanceOf(address account) external view returns (uint);

}

contract Pair {

  bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
  
  uint public constant MINIMUM_LIQUIDITY = 10**3;

  address public factory;
  address public token0;
  address public token1;

  uint256 private reserve0;
  uint256 private reserve1;
  uint32 private blockTimestampLast;

  uint256 public price0CumulativeLast;
  uint256 public price1CumulativeLast;
  uint256 public kLast;

  uint256 private unlocked = 1;

  // Reentrancy guard
  modifier lock() {
    require(unlocked == 1, "Locked"); // Requires that unlocked
    unlocked = 0; // Locks to prevent reentrancy
    _; // Runs code
    unlocked = 1; // Unlocks
  }

  function getReserves() public view returns (uint256 _reserve0, uint256 _reserve1, uint32 _blockTimestampLast) {
    _reserve0 = reserve0;
    _reserve1 = reserve1;
    _blockTimestampLast = blockTimestampLast;
  }

  constructor(address _token0, address _token1) {
    require(msg.sender == factory, "Only factory can create pairs");
    token0 = _token0;
    token1 = _token1;
  }

  function _safeTransfer(address token, address to, uint256 value) internal {
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
  }

  function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private {
    
  }

  function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external lock {
    require(amount0Out > 0 || amount1Out > 0, "Insufficient output amount");
    (uint256 _reserve0, uint256 _reserve1, ) = getReserves();
    require(amount0Out < _reserve0 && amount1Out < _reserve1, "Insufficient liquidity");

    uint256 balance0;
    uint256 balance1;

    address _token0 = token0;
    address _token1 = token1;

    require(to != _token0 && to != _token1, "Invalid to");

    // if (amount0Out > 0
  }

  function mint(address to) external lock returns (uint256 liquidity) {
    (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
    uint256 balance0 = IERC20(token0).balanceOf(address(this));
    uint256 balance1 = IERC20(token1).balanceOf(address(this));
    uint256 amount0 = balance0 - _reserve0;
    uint256 amount1 = balance1 - _reserve1;

    bool feeOn = _mintFee(_reserve0, _reserve1);
    uint256 _totalSupply = totalSupply;
    if (_totalSupply == 0) {
      liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
      _mint(address(0), MINIMUM_LIQUIDITY);
    } else {
      liquidity = Math.min(amount0 * _totalSupply / _reserve0, amount1 * _totalSupply / _reserve1);
    }

    require(liquidity > 0, "Insufficicent liquidity minted");
    _mint(to, liquidity);

    if (feeOn) kLast = uint256(reserve0) * reserve1;

  }
 }