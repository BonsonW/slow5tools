#!/bin/bash
# merge four single group slow5s and diff with expected slow5 to check if slow5tools merge is working as expected

# WARNING: this file should be stored inside test directory
# WARNING: the executable should be found at ../
# WARNING: four slow5s should be found at ./data/test/merge/slow5s
# WARNING: expected slow5 should be found at ./data/test/merge/

Usage="merge_integrity.sh"

# Relative path to "slow5/tests/"
REL_PATH="$(dirname $0)/" 

if [[ "$#" -ne 0 ]]; then
	echo "Usage: $Usage"
	exit
fi

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'

SLOW5_EXEC=$REL_PATH/../slow5tools
OUTPUT_DIR="$REL_PATH/data/out/merge"
test -d  $OUTPUT_DIR
rm -r $OUTPUT_DIR
mkdir $OUTPUT_DIR

echo "-------------------slow5tools version-------------------"
$SLOW5_EXEC --version

echo
echo "-------------------merging-------------------"
if ! $SLOW5_EXEC merge $REL_PATH/data/exp/merge/slow5s -o $OUTPUT_DIR/merged_output.slow5 -b slow5; then
    echo "merge failed" 
    exit 1
fi

echo "comparing merged_output and merged_expected"
cmp -s $REL_PATH/data/exp/merge/merged_expected.slow5 $OUTPUT_DIR/merged_output.slow5

if [ $? -eq 0 ]; then
    echo -e "${GREEN}SUCCESS: merged files are consistent!${NC}"
elif [ $? -eq 1 ]; then
    echo -e "${RED}FAILURE: merged files are not consistent${NC}"
else
    echo -e "${RED}ERROR: diff failed for some weird reason${NC}"
fi


echo
echo "-------------------lossy merging-------------------"
if ! $SLOW5_EXEC merge -l $REL_PATH/data/exp/merge/slow5s -o $OUTPUT_DIR/lossy_merged_output.slow5 -b slow5; then
    echo "merge failed" 
    exit 1
fi

echo "comparing lossy_merged_output and lossy_merged_expected"
cmp -s $REL_PATH/data/exp/merge/lossy_merged_expected.slow5 $OUTPUT_DIR/lossy_merged_output.slow5

if [ $? -eq 0 ]; then
    echo -e "${GREEN}SUCCESS: lossy merged files are consistent!${NC}"
elif [ $? -eq 1 ]; then
    echo -e "${RED}FAILURE: lossy merged files are not consistent${NC}"
else
    echo -e "${RED}ERROR: diff failed for some weird reason${NC}"
fi

exit

