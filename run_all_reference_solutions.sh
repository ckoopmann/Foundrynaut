#!/bin/bash
for ProblemName in 00_HelloEthernaut 01_Fallback 02_Fallout 03_CoinFlip 04_Telephone 05_Token 06_Delegate
do
    sh ./run_reference_solution.sh $ProblemName $@
done
