// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GigEscrow {
    address public client;
    address public freelancer;
    uint256 public gigCompletionTimestamp;

    IERC20 public usdcToken; // Assuming USDC is an ERC-20 token

    constructor(address _client, address _freelancer, address _usdcToken) {
        client = _client;
        freelancer = _freelancer;
        usdcToken = IERC20(_usdcToken);
    }

    modifier onlyClient() {
        require(msg.sender == client, "Only the client can call this function");
        _;
    }

    modifier onlyFreelancer() {
        require(msg.sender == freelancer, "Only the freelancer can call this function");
        _;
    }

    function fundEscrow(uint256 amount) external onlyClient {
        usdcToken.transferFrom(client, address(this), amount);
    }

    function completeGig() external onlyFreelancer {
        gigCompletionTimestamp = block.timestamp;
    }

    function withdrawFunds() external {
        require(block.timestamp > gigCompletionTimestamp, "Gig not completed yet");
        usdcToken.transfer(client, usdcToken.balanceOf(address(this)));
    }
}

