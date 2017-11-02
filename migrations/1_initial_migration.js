var JuryVotes = artifacts.require("./JuryVotes.sol");

module.exports = function(deployer) {
  deployer.deploy(JuryVotes);
};
