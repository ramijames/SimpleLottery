const SimpleLottery = artifacts.require("SimpleLottery");

contract("SimpleLottery", (accounts) => {
  let SimpleLotteryInstance;

  beforeEach(async () => {
    SimpleLotteryInstance = await SimpleLottery.new();
  });

  it("should enter the lottery", async () => {
    const amountToSend = web3.utils.toWei(".1", "ether");
    const result = await SimpleLotteryInstance.enter({ value: amountToSend });
  });
});
