const BEP20_Token = artifacts.require('BEP20_Token.sol');

module.exports = function (deployer) {
    deployer.deploy(BEP20_Token);
}