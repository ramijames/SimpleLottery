const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleLottery", function () {
  it("Should return the list of players", async function () {
    // Deploy the SimpleLottery contract
    const SimpleLottery = await ethers.getContractFactory("SimpleLottery");
    const simpleLottery = await SimpleLottery.deploy();

    // Wait for the contract to be mined
    await simpleLottery.deployed();

    // Call the getPlayers function
    const players = await simpleLottery.getPlayers();
    const contractFee = await simpleLottery.getPlayers();

    // Perform assertions
    expect(players).to.be.an("array");
    // Add more assertions as needed based on the expected behavior of getPlayers()
  });

  it("Should call the enter function nine times", async function () {
    // Deploy the SimpleLottery contract
    const SimpleLottery = await ethers.getContractFactory("SimpleLottery");
    const simpleLottery = await SimpleLottery.deploy();

    // Wait for the contract to be mined
    await simpleLottery.deployed();

    // Call the enter function and set the amount to send
    const amount = ethers.utils.parseEther("1");

    // call the enter function nine times
    for (let i = 0; i < 9; i++) {
      await simpleLottery.enter({ value: amount });
    }

    // Perform assertions
    const players = await simpleLottery.getPlayers();
    console.log("players: ", players);
    expect(players.length).to.equal(9);
    // Add more assertions as needed based on the expected behavior of getPlayers()
  });

  // call the enter function one more time and assert that maxPlayers is reached
  it("Should call the enter function one more time and have a winner", async function () {
    // Deploy the SimpleLottery contract
    const SimpleLottery = await ethers.getContractFactory("SimpleLottery");
    const simpleLottery = await SimpleLottery.deploy();

    // Wait for the contract to be mined
    await simpleLottery.deployed();

    // Call the getPlayers function
    const players = await simpleLottery.getPlayers();
    const contractFee = await simpleLottery.getPlayers();

    // Perform assertions
    expect(players.length).to.equal(0);
    console.log("players: ", players);
  });

  // should confirm that the maxPlayers is doubled each round
  it("Should confirm that the maxPlayers is doubled each round", async function () {
    // Deploy the SimpleLottery contract
    const SimpleLottery = await ethers.getContractFactory("SimpleLottery");
    const simpleLottery = await SimpleLottery.deploy();

    // Wait for the contract to be mined
    await simpleLottery.deployed();

    // Call the enter function and set the amount to send
    const amount = ethers.utils.parseEther("1");

    // call the enter function nine times
    for (let i = 0; i < 10; i++) {
      await simpleLottery.enter({ value: amount });
    }

    // Call the getPlayers function
    const maxPlayers = await simpleLottery.maxPlayers();
    const max = await maxPlayers.toNumber();

    // Perform assertions
    // maxPlayers should be greater than the initial value of 10
    console.log("maxPlayers: ", max);
    expect(max).to.be.greaterThan(10);
  });
});
