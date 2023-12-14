// SPDX-license-identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;
    uint public maxPlayers;
    address payable[] public players;
    uint public currentLotteryId;

    struct Lottery {
        uint256 id;
        address payable[] players;
        address payable winner;
        uint256 maxPlayers;
        uint256 prize;
        uint contractFee;
        uint256 createdAt;
        uint256 updatedAt;
    }

    constructor() {
        manager = msg.sender;
        maxPlayers = 0; // Set an initial value for maxPlayers
    }

    function startLottery() public restricted {
        require(maxPlayers > 0, "Max players not set");
        createLottery(maxPlayers);
    }

    function createLottery(uint256 _maxPlayers) public restricted {
        Lottery memory newLottery;
        newLottery.id = currentLotteryId + 1;
        newLottery.players = players;
        newLottery.winner = address(0);
        newLottery.maxPlayers = maxPlayers;
        newLottery.prize = address(this).balance;
        newLottery.createdAt = block.timestamp;
        newLottery.updatedAt = block.timestamp;
        currentLotteryId = newLottery.id;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Not enough ether");
        require(players.length < maxPlayers, "Max players reached");
        players.push(payable(msg.sender));
        if (players.length == maxPlayers) {
            pickWinner();
        }
    }

    function pickWinner(uint _contractFee) private {
        uint256 index = random() % players.length;
        address payable winner = players[index];
        uint256 payout = address(this).balance - _contractFee;
        winner.transfer(payout);
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }
}

