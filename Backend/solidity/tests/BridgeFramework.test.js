// File: test/StellarToAaveBridge.test.js
const StellarToAaveBridge = artifacts.require('StellarToAaveBridge');
const USDCMock = artifacts.require('USDCMock');

contract('StellarToAaveBridge', (accounts) => {
  let bridgeInstance;
  let usdcInstance;

  const owner = accounts[0];
  const nonOwner = accounts[1];

  beforeEach(async () => {
    usdcInstance = await USDCMock.new();
    bridgeInstance = await StellarToAaveBridge.new(usdcInstance.address, 'AaveLendingPoolAddress');
  });

  it('should transfer USDC from Stellar to AAVE', async () => {
    const amountToTransfer = 1000;

    // Approve the bridge to spend USDC on behalf of the owner
    await usdcInstance.approve(bridgeInstance.address, amountToTransfer, { from: owner });

    // Perform the transfer from Stellar to AAVE
    await bridgeInstance.transferToAave(amountToTransfer, { from: owner });

    // You may want to add assertions to check the state after the transfer
    const ownerUSDCBalance = await usdcInstance.balanceOf(owner);
    const bridgeUSDCBalance = await usdcInstance.balanceOf(bridgeInstance.address);

    assert.equal(ownerUSDCBalance.toNumber(), 999000, 'Incorrect owner balance after transfer');
    assert.equal(bridgeUSDCBalance.toNumber(), 1000, 'Incorrect bridge balance after transfer');
  });

  it('should not allow non-owner to transfer USDC to AAVE', async () => {
    const amountToTransfer = 1000;

    // Approve the bridge to spend USDC on behalf of the owner
    await usdcInstance.approve(bridgeInstance.address, amountToTransfer, { from: owner });

    // Attempt to transfer from Stellar to AAVE by a non-owner
    try {
      await bridgeInstance.transferToAave(amountToTransfer, { from: nonOwner });
      assert.fail('Expected an error');
    } catch (error) {
      assert.include(error.message, 'Not the owner', 'Unexpected error message');
    }
  });
});
