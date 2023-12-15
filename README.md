# Simple Lottery

This is a simple lottery system in Solidity which can be deployed to EVMs.

## How it works

Each lottery has a maximum number of participants. The contract owner must set this on deployment. Default is 10.

Each new lottery will run until the max number of participants is reached. Upon completion the contract will pay out to the randomly selected winner.

There is a contract fee which is subtracted from the total contract payout. This contract fee is set on deployment.

At the end of each round:

1. The winner is paid out
2. The manager gets his fee
3. Players are reset
4. The maximum number of players is increased

## Testing

Testing is using Hardhat.

You can run the tests with:

```sh
npx hardhat test
```

Coverage includes:

- Should return the list of players
- Should call the enter function nine times which confirms that up to the maxPlayers it allows more players
- Should call the enter function one more time and have a winner which also resets the lottery to a zero state
- Should confirm that the maxPlayers is doubled each round
