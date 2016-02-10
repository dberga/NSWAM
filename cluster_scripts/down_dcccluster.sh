#!/bin/bash

defarg1="nd";
defarg2="output/";

if [ $# -eq 0 ]
then  
	arg1="$defarg1";
	arg2="$defarg2";
else
	if [ $# -eq 1 ]
	then  
		arg1=$1;
		arg2="$defarg2";
	else
		arg1=$1;
		arg2=$2;
	fi
fi


rm -r -f ../$arg2

sshpass -p'IjnRfv33' scp -r -P 22 dberga@dcccluster.uab.es:neuro/$arg1/$arg2 ../$arg2;
