# Simple Lottery

This is a simple lottery system in Solidity which can be deployed to EVMs.

## How it works

Each lottery has a maximum number of participants. The contract owner must set this on deployment.

Each new lottery will run until the max number of participants is reached. Upon completion the contract will pay out to the randomly selected winner.

There is a contract fee which is subtracted from the total contract payout. This contract fee is set on deployment.
