#!/bin/ksh

# Build the list of patterns
#
while getopts "aefilvwx:" option
do
	flags="$flags $OPTARG"
done

shift $((${OPTIND} - 1)) 

extentions="$*"

for ext in $extentions
do
	typelist="$typelist -x $ext"
done

echo fn $(eval echo $flags $typelist)
fn $flags $typelist

exit 0

