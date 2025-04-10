#!/bin/bash

# Build the list of patterns
#
while getopts "aefilLvwx:" option
do
    echo $OPTARG
	flags="$flags -${option} $OPTARG"
done

shift $((${OPTIND} - 1)) 

extentions="$*"

for ext in $extentions
do
	typelist="$typelist -x $ext"
done

#echo fn $(eval echo $flags $typelist)
fn $flags $typelist

exit 0

