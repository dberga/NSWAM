
	
path_folder="${PWD}";
for conf in */
do
	#echo "${path_folder}/${conf}gaussian"
	if [ -e "${path_folder}/${conf}gaussian" ]
	then
		cd ${path_folder}/${conf};
		conf_name=${PWD##*/};
		cd gaussian;
		for gaze in *
		do
			name_gaussian_smaps="gaussian_${gaze}_${conf_name}";
			cd ..; cd ..;
			ln -s "${conf_name}/gaussian/${gaze}" "$name_gaussian_smaps"
			echo "${conf_name}/gaussian/${gaze}"
			echo "$name_gaussian_smaps"
			cd "${conf}/gaussian";
		done
	else
		echo ''		
		#echo "${conf} has no gaussian"
	fi
done


