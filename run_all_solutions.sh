#!/bin/bash
for ProblemName in 00_HelloEthernaut 01_Fallback 02_Fallout 03_CoinFlip 04_Telephone 05_Token 06_Delegate 07_Force 08_Vault 09_King 10_Reentrancy 11_Elevator 12_Privacy 13_GatekeeperOne 14_GatekeeperTwo 15_NaughtCoin 16_Perservation 17_Recovery 18_MagicNumber
do
    sh ./run_solution.sh $ProblemName $@
done
