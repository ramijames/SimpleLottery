// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;

    uint256 public maxPlayers;
    uint256 public contractFee;

    address payable[] public players;
    address payable public winner;
    address payable public earningsWallet;
    uint256 public prize;

    constructor() {
        manager = payable(msg.sender);
        earningsWallet = payable(0x81f9E50f0F1f509eEF083Ff6d6Fa36caB15D6Bca);
        contractFee = 9;
        maxPlayers = 10; // first run
    }

    function changeManager(address _newManager) public restricted {
        manager = payable(_newManager);
    }

    function changeContractFee(uint256 _newFee) public restricted {
        contractFee = _newFee;
    }

    function reset() public restricted {
        players = new address payable[](0);
        winner = payable(address(0));
        prize = 0;
        maxPlayers = maxPlayers * 2;
    }

    function finishRound() internal {
        require(players.length == maxPlayers, "Invalid number of players");
        uint256 index = random() % players.length;
        winner = players[index];

        prize = (prize * 9) / 10;
        players = new address payable[](0);

        winner.transfer(prize);
        earningsWallet.transfer(address(this).balance);

        reset();
    }

    function enter() public payable {
        require(msg.value > contractFee, "Not enough ether");
        require(players.length < maxPlayers, "Max players reached");
        players.push(payable(msg.sender));

        prize += msg.value;

        if (players.length == maxPlayers) {
            finishRound();
        }
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // function to return maxPlayers
    function getMaxPlayers() public view returns (uint256) {
        return maxPlayers;
    }

    // This is dangerous! Recommended to use a public RNG oracle like Chainlink VRF
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

}

