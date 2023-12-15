var SimpleLottery = artifacts.require("SimpleLottery");

module.exports = function (deployer) {
  // deployment steps
  deployer.deploy(SimpleLottery);
};
