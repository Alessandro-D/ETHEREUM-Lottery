// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


// A lottery that participants can enter with 0.00001 ETH
// in order for a randomly chosen participant to win the total
contract Lottery {
    address public owner;
    address payable[] public players;

    constructor() {
        // Owner address
        owner = msg.sender;
    }

    // Enter the lottery with the predefined amount of ETH
    function enter() public payable {
        require(msg.value > .00001 ether);
        // Player address
        players.push(payable(msg.sender));
    }

    // Getting the current balance held in the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // Approximate a randoma number
    function getRandomN() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // Choose the Winner based on the random number generated
    function pickWinner() public onlyOwner {
        uint index = getRandomN() % players.length;
        players[index].transfer(address(this).balance);
        // Reset contract state after winner is picked
        players = new address payable[](0);
    }

    // This modifier only lets a function be executed by the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}