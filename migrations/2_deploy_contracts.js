const StarNotary = artifacts.require("StarNotary");
const MetaHash = artifacts.require("MetaHash");

module.exports = function(deployer) {
  deployer.deploy(StarNotary);
  deployer.deploy(MetaHash);
};
