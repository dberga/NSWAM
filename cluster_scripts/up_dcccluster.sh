
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


#sshpass -p'IjnRfv33' ssh -p 22 dberga@dcccluster.uab.es 'rm -r -f neuro/$arg1/"$arg2"'
sshpass -p'IjnRfv33' scp -r -P 22 ../$arg2 dberga@dcccluster.uab.es:neuro/$arg1/
