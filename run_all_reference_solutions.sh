#!/bin/bash
for ProblemName in 00_HelloEthernaut 01_Fallback
do
    sh ./run_reference_solution.sh $ProblemName $@
done
