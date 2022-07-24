[![test](https://github.com/ckoopmann/Foundrynaut/actions/workflows/test.yml/badge.svg)](https://github.com/ckoopmann/Foundrynaut/actions/workflows/test.yml)
# Foundrynaut
Solution to all [Ethernaut](https://ethernaut.openzeppelin.com/) problems implemented as [foundry solidity scripts](https://book.getfoundry.sh/tutorials/solidity-scripting)

## Setup
1. [Install foundry](https://book.getfoundry.sh/getting-started/installation)
2. Set environment variables for 
    - `FORK_URL`(url of rinkeby network rpc from a provider such as alchemy)
    - `PRIVATE_KEY` private key of account you want to use to submit solutions. (Needs to have sufficient rinkeby eth - NEVER SHARE OR COMMIT THIS TO ANY REPO)

## Run Solutions
- Run a single solution: `sh run_solution.sh 00_HelloEthernaut` (to actually submit your solution on chain add `--broadcast` option)
- Run all solutions `sh run_all_solutions.sh`

(both commands need to be run from the root of this repository)

## Foundry Scripting issues / painpoints
I did this mainly as an exercise to better learn foundry / forge in general and the solidity scripting feature in particular as well as evaluating it as an alternative to writing scripts in Javascript.
While these solidity scripts have many great advantages over JS scripting I also encountered a few issues / lack of functionality compared to JS scripts (which I usually implement with `ethers.js` and `hardhat`).
This description refers to `forge 0.2.0 (f016135 2022-07-04T00:15:02.930499Z)`, and might contain issues that are fixed in later versions. (In which case feel welcome to create an issue so that I can update this list as well as my implementations)

### No transaction specific gas limits
#### Problem
There is no way to specify a gas limit for a specific transaction / contract call in forge solidity scripts. 
#### Workaround
I had to deploy separate contracts so that I could use soliditys `contract.method{gas: gas}()` syntax to specify gas limits. (see [GatekeeperOne solution](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/problems/13_GatekeeperOne/SolutionScript.sol#L19))
However this still lead to issues in some cases since the gas estimation would ignore these values and the script would then try to run the respective call with a gasLimit lower than the one specified in the nested call. The only workaround I found for that was to manually waste enough gas during simulation. (see [here](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/problems/13_GatekeeperOne/SolutionScript.sol#L22))

#### Problem
Simulation of on-chain transactions behave as if all of them were included in the same block, even when running with `--slow` (which should ensure that this is not actually the case when broadcasting). (`vm.roll` calls are also ignored during that simulation)
#### Workaround
This was a problem when implementing the `CoinFlip` solution which requires each call to be on a separate block.
To solve it in this case I had to add very ugly logic that lead to the contract to skip certain parts of the implementation in the on-chain simulation step. (see [here](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/problems/03_CoinFlip/SolutionScript.sol#L20))

### No `callStatic` equivalent
#### Problem
No static calls to state changing methods possible. (i.e. no equivalent of `ethers.js` `contract.callStatic.method()` syntax  / `eth_staticCall` which triggers [eth_call](https://www.quicknode.com/docs/ethereum/eth_call) rpc endpoint).
Note that, while contract calls outside of `broadcast` blocks will not actually be submitted they still change the simulated state inside the script.
#### Workaround
I used the pattern of throwing a revertion, ignoring that revertion and returning the revertdata, which I used to get the address of a deployed level instance [here](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/common/EthernautScript.sol#L40). (Note that I had to actually route this call through another contract to avoid below issue regarding reverts, so it is not actually equivalent to doing a `staticCall` from `tx.origin`)

### No top level revertion handling
#### Problem
Cannot catch / ignore revertions thrown in the script implementation. Revertions that are thrown in the ethernaut script directly always lead to the script aborting. I tried the following approaches none of which did the trick:
- Handle revertion with `try / catch`
- Ignore revertion with `(bool success, bytes memory data) = address(contract).call(encodedCallData)` syntax. 
- Expect revertiotn with `vm.expectRevert`
#### Workaround
I had to create a separate contract instance (even though its deployment will not be actually broadcasted) inside which I handled the revrtion. (see [here](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/common/EthernautScript.sol#L74))

### `selfdestruct` has no effect during script runtime
#### Problem
No way to test / assert the results of a `selfdestruct` call. (see related issue [here](https://github.com/foundry-rs/foundry/issues/1543)).
#### Workaround
I didn't find a workaround for this one. I had to disable validating the solution for the `Motorbike` solution [here](https://github.com/ckoopmann/Foundrynaut/blob/b9d8d29f022fcf55942d6571e50fdf0fe505d746/src/problems/25_Motorbike/SolutionScript.sol#L38).

