PROBLEM_NAME=$1 # save positional arg
shift # past argument
if [[ $PROBLEM_NAME == "03_CoinFlip" ]]
then
    set -- "$@" '--slow' 
fi
forge script src/${PROBLEM_NAME}/SolutionScript.sol:SolutionScript --fork-url=$FORK_URL --private-key=$PRIVATE_KEY $@

