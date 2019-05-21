#!/bin/bash

#-----------------------------------------------------------
#
# verify-hash: calculates and compares hashs
#
# Written by Angelo Varlotta, September 15, 2015
# Last updated on May 24, 2018
#
#-----------------------------------------------------------

usage()
{
	echo "Usage: $(basename "$0") [-h] <hash type> <file name> <hash file>"
	echo
	echo "The arguments are the message digest, the name of the file to calculate"
	echo "the hash of and the file containing the hash itself, downloaded separately."
	echo "All openssl message digest algorithms are accepted in $(basename "$0"). See"
	echo "'openssl dgst' man page for more options."
	echo
	echo "Options:"
	echo
	echo " -h	Display this help message."
	echo
}

while getopts "h" opt
do
	case $opt in
	h) usage ; exit;;
	esac

done

if [ $# = 0 ]
then
	usage
	exit
fi

# Specifies hash type used
dgst_type=$1
# Message digest algorithm must be one of the following in the list:
dgst_list="md4 md5 mdc2 ripemd160 sha sha1 sha224 sha256 sha384 sha512 whirlpool"
# file to check the hash of
file1=$2
# file containing the correct hash the file must have
file2=$3

testHash(){
	echo
	echo "$hash_output"
	echo $(cat $file2)
	echo
	if [ "$hash_output" != $(cat $file2 | cut -d' ' -f1) ]
	then
		echo "$dgst_type sums mismatch"
	else
		echo "checksums OK"
	fi
}

calculateHash(){
	hash_output=$(openssl $dgst_type $file1 | cut -d' ' -f2)
	echo "Checking file: $file1"
	echo "Using $dgst_type file: $file2"
}

if [[ -f $file1 && -f $file2 && -n $dgst_type ]]
then
	for item in $dgst_list
	do
	    if [ "$dgst_type" == "$item" ]
		then
			calculateHash
			testHash
			exit
		fi
	done
	for item in $dgst_list
	do
		if ! [ "$dgst_type" == "$item" ]
		then
			echo "You must specify the message digest algorithm"
			echo "to be one of the following:"
			echo
			echo "md4, md5, mdc2, ripemd160, sha, sha1, sha224,"
			echo "sha256, sha384, sha512 and whirlpool."
			exit
		fi
	done
else
	echo "You need to specify the correct files in the proper order. Follow usage below."
	echo
	usage
	exit
fi
