// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HederaBridge {
    address public owner;
    IERC20 public usdcToken;

    constructor(address _usdcToken) {
        owner = msg.sender;
        usdcToken = IERC20(_usdcToken);
    }

    function deposit(uint256 amount) external {
        require(usdcToken.transferFrom(msg.sender, address(this), amount), "USDC transfer failed");
        // Additional logic to trigger the Hedera side of the bridge
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        // Additional logic to trigger the Ethereum side of the bridge
        usdcToken.transfer(owner, amount);
    }
}
