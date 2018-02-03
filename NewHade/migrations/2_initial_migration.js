
var HadeCoin = artifacts.require("./HadeCoin.sol");

// Rogers metamask multisig
/** CHANGE FOR REAL DEPLOY */

var owner = "0xBAE2175539624c861920C9566486DA79b582D362";

module.exports = function(deployer) {
  deployer.deploy(HadeCoin, owner);
};
