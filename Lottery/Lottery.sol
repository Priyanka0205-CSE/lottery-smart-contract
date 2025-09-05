// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 10 wei, "Please pay exactly 1 ether");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only manager can view balance");
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager, "Only manager can pick winner");
        require(players.length >= 3, "At least 3 players required");

        uint index = random() % players.length;
        winner = players[index];
        winner.transfer(address(this).balance);
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
