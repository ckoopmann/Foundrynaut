#!/bin/bash
for ProblemName in 00_HelloEthernaut 01_Fallback 02_Fallout 03_CoinFlip 04_Telephone 05_Token 06_Delegate 07_Force 08_Vault 09_King 10_Reentrancy 11_Elevator 12_Privacy 13_GatekeeperOne 14_GatekeeperTwo 15_NaughtCoin 16_Perservation 17_Recovery 18_MagicNumber 19_AlienCodex 20_Denial 21_Shop 22_Dex 23_DexTwo 24_PuzzleWallet 25_Motorbike 26_DoubleEntryPoint
do
    sh ./run_solution.sh $ProblemName $@
done
