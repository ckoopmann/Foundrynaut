#!/bin/bash
for ProblemName in  $(ls src/problems/)
do
    echo "Running solution for: $ProblemName"
    sh ./run_solution.sh $ProblemName $@
done
