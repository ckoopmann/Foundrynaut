#!/bin/bash
for ProblemName in 00_HelloEthernaut 01_Fallback 02_Fallout 03_CoinFlip 04_Telephone 05_Token 06_Delegate 07_Force 08_Vault 09_King 10_Reentrancy
do
    sh ./run_solution.sh $ProblemName $@
done
