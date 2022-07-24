PROBLEM_NAME=$1 # save positional arg
shift # past argument
if [[ $PROBLEM_NAME == "03_CoinFlip" ]]
then
    set -- "$@" '--slow' # For this problem we have to make sure transactions are mined on different blocks
fi
if [[ $PROBLEM_NAME == "18_MagicNumber" ]]
then
    set -- "$@" '--ffi'  # For this problem we use an ffi command to compile yul
fi
forge script src/problems/${PROBLEM_NAME}/SolutionScript.sol:SolutionScript --fork-url=$FORK_URL --private-key=$PRIVATE_KEY $@

