// SPDX-license-identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {

    address public manager;

    struct Lottery {
        uint256 id;
        address payable[] players;
        address payable winner;
        uint256 maxPlayers;
        uint256 prize;
        uint256 createdAt;
        uint256 updatedAt;
    }
    
    // Function to start the lottery. First you have to check if the maxPlayers has been set by the manager. If so, you can start a lottery with an incremented id
    function startLottery(uint256 _maxPlayers) public {
        require(_maxPlayers > 0, "Max players must be greater than 0");
        require(maxPlayers == 0, "Lottery started");
        maxPlayers = _maxPlayers;
        manager = msg.sender;
        id = id + 1;
        createdAt = block.timestamp;
    }

    // Function to enter the lottery. Each player will send ether to this contract and will be added to the players array. If the maxPlayers is reached, the lottery will be closed and a winner will be picked using the pickWinner function
    function enter() public payable {
        require(msg.value > 0.01 ether, "Not enough ether");
        require(players.length < maxPlayers, "Max players reached");
        players.push(payable(msg.sender));
        if (players.length == maxPlayers) {
            pickWinner();
        }
    }

    // Function to randomly pick a winner from the players array. The winner will receive the prize and the players array will be resetted
    function pickWinner() private {
        uint256 index = random() % players.length;
        winner = players[index];
        winner.transfer(address(this).balance);
        players = new address payable[](0);
        prize = address(this).balance;
        updatedAt = block.timestamp;
    }

    // Function to list all players publicly, which can be used to display the players on the frontend
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }
}