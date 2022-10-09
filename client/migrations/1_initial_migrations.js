

//const artifacts=require("../src/abis/DSkill.json")

const dSkill = artifacts.require('DSkill');
module.exports = function (deployer) {
  deployer.deploy(dSkill);
};