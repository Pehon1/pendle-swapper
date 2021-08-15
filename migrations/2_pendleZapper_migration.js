var pendleZapper = artifacts.require("PendleZapper");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy()
  deployer.deploy(pendleZapper);
};