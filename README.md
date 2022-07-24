# Issues
- No transaction specific gas limits  (Gatekeeper)
- Simulation treats transactions as if they are all on the same block even when using --slow (CoinFlip)
- Sending funds with selfdestruct to tx.origin leads to stack overflow (unable to reproduce now)
- Cannot static call state changing contract methods inside script the way you can in ethers.js with `contract.staticCall.methodName()`
- Cannot `vm.expectRevert` inside forge script (Denial), also cannot `try catch` reverts in script. (leading to very ugly implementation of static call workaround)
- (Ethernaut issue) Add revert message in denial when creating instance without providing enough funds
- No way to test results of selfdestruct (Motorbike)
- No abstract contract inheritance for script

