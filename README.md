[![test](https://github.com/ckoopmann/Foundrynaut/actions/workflows/test.yml/badge.svg)](https://github.com/ckoopmann/Foundrynaut/actions/workflows/test.yml)
# Foundrynaut
Solution to all [Ethernaut](https://ethernaut.openzeppelin.com/) problems implemented as [foundry solidity scripts](https://book.getfoundry.sh/tutorials/solidity-scripting)

## Setup
1 [Install foundry](https://book.getfoundry.sh/getting-started/installation)
2 Set environment variables for 
    - `FORK_URL`(url of rinkeby network rpc from a provider such as alchemy)
    - `PRIVATE_KEY` private key of account you want to use to submit solutions. (Needs to have sufficient rinkeby eth - NEVER SHARE OR COMMIT THIS TO ANY REPO)

## Run Solutions
- Run a single solution: `sh run_solution.sh 00_HelloEthernaut` (to actually submit your solution on chain add `--broadcast` option)
- Run all solutions `sh run_all_solutions.sh`

## Foundry Scripting issues / painpoints
- No transaction specific gas limits  (Gatekeeper)
- Simulation treats transactions as if they are all on the same block even when using --slow (CoinFlip)
- Sending funds with selfdestruct to tx.origin leads to stack overflow (unable to reproduce now)
- Cannot static call state changing contract methods inside script the way you can in ethers.js with `contract.staticCall.methodName()`
- Cannot `vm.expectRevert` inside forge script (Denial), also cannot `try catch` reverts in script. (leading to very ugly implementation of static call workaround)
- (Ethernaut issue) Add revert message in denial when creating instance without providing enough funds
- No way to test results of selfdestruct (Motorbike)
- No abstract contract inheritance for script

