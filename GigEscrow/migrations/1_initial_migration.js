// Truffle migration script (if using Truffle)
const GigEscrow = artifacts.require("GigEscrow");

module.exports = function (deployer) {
    deployer.deploy(GigEscrow, /* constructor arguments if any */);
};

