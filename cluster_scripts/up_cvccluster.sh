#!/bin/bash

defarg1="nd";
defarg2="*";

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


#sshpass -p'dvid1680' ssh -p 22345 dberga@158.109.8.100 'rm -r -f neuro/$arg1/"$arg2"'
sshpass -p'dvid1680' scp -P 22345 -r ../$arg2 dberga@158.109.8.100:neuro/$arg1/
#158.109.8.100 or cluster1.cvc.uab.es

