#!/bin/ksh

# Build the list of patterns
#
typeset extentions=
typeset typelist
typeset grepargs
typeset findargs
typeset findLinks
typeset edit=false
typeset canedit=true

function DieUsage
{
	print "Usage: $0 [-x ext1 -x ext2] [-ilvw] words to search for"
	print ""
	print "\tExample: $0 -i -x sdl -x soc interface"
	print "\twill perform a 'grep -i' on all files below the current"
	print "\tdirectory that end in the pattern sdl or soc"

	exit 1
}

if [ $# -eq 0 ]
then
	DieUsage
fi

while getopts "aefilvwx:" option
do
	case $option in 
		a)
			findLinks="-o -type l"
			;;
		e)
			edit=true
			;;
		i|l|v|w)
			if [ $option = "l" ]
			then
				canedit=true
			fi

			grepargs="$grepargs -${option}"
			;;
		
		x)
			extentions="$extentions $OPTARG"
	esac
done

shift $((${OPTIND} - 1)) 

extentions="$*"

for pattern in $extentions
do
	if [ -n "$typelist" ]
	then
		typelist="$typelist -o "
	fi	
	typelist="${typelist}-name \"*.${pattern}\""
done

findargs="\( -type f $findLinks \)"

if [ -n "$typelist" ]
then
	findargs="$findargs -a \( $typelist \)"
fi

# Don't want to expand the *'s, in case there are matching file names in this
# dir
#

set -o noglob

# Trying this to see if we can handle filenames with spaces
#
# JRS-TMP find . -path '*/CVS*' -prune -or $(eval echo $findargs) -print0| \
# JRS-TMP 	xargs -0 -n1 grep $grepargs "$*" /dev/null

function doFind
{
	find . -path 'CVS' -prune \
		-or -path '.svn' -prune \
		-or -path 'ossm' -prune \
		-or $(eval echo $findargs) 
}

function doFindOld
{
    find . $(eval echo $findargs) | grep -v ~$
}

if [ $edit = "true" -a $canedit = "true" ]
then
	emacs $(doFind "$*")
else
	doFind $*
fi

exit 0

