// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;

    struct Lottery {
        address payable[] players;
        address payable winner;
        uint256 maxPlayers;
        uint256 prize;
        uint contractFee; // Percentage of the prize that goes to the contract
    }

    Lottery public lottery;

    constructor() {
        manager = payable(msg.sender);
    }

    function createLottery() public restricted {
        lottery = Lottery({
            players: new address payable[](0),
            winner: payable(address(0)), // sets the winner to the zero address for each new lottery
            maxPlayers: 100,
            prize: address(this).balance,
            contractFee: 10
        });
    }

    function startLottery() public restricted {
        require(lottery.maxPlayers > 1, "Max players is too low");
        createLottery();
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Not enough ether");
        require(lottery.players.length < lottery.maxPlayers, "Max players reached");
        lottery.players.push(payable(msg.sender));
        if (lottery.players.length == lottery.maxPlayers) {
            pickWinner();
        }
    }

    function pickWinner() private {
        require(lottery.players.length > 0, "No players in the lottery");

        uint256 index = random() % lottery.players.length;
        address payable winner = lottery.players[index];
        uint256 payout = address(this).balance - lottery.contractFee;

        lottery.players = new address payable[](0);

        // Perform the external call last
        winner.transfer(payout);
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // **This is dangerous!** Recommended to use a public RNG oracle like Chainlink VRF
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, lottery.players.length)));
    }

    // Fallback function to handle accidental ETH transfers
    receive() external payable {
        // You can log the event or perform any other necessary actions
        emit EtherReceived(msg.sender, msg.value);
    }

    // Event to log accidental ETH transfers
    event EtherReceived(address indexed sender, uint256 value);

}

