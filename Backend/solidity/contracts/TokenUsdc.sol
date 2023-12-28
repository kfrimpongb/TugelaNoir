pragma solidity ^0.8.0;

import './TokenBase.sol';

contract TokenUsdc is ERC20 {
  constructor() TokenBase('USDC Token', 'USDCM') {
    _mint(msg.sender, 1000000 * 10**decimals());
  }
}