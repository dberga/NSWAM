

function [] = executa(input_dir, conf_dir, output_dir, mats_dir, fileformat,output_extension, funcio)

if nargin < 1

input_dir = 'input';
output_dir = 'output';
mats_dir = 'mats';
conf_dir = 'conf';
fileformat = 'jpg';
output_extension = 'png';
funcio = 'saliency';

end

%function dependencies
addpath('include/file_utils');
addpath(genpath('include'));

%NCZLd - Xavi/Xim/David
addpath('src');
addpath('src_mex');

conf_mats= dir(fullfile(conf_dir, ['*.mat']));
conf_mats=unsort_array(conf_mats);


 %delete(gcp);
 %parpool('local',4);

mkdir('logs');
done_name=['logs/' 'done_' conf_mats(i).name];

for i=1:length(conf_mats) %parfor i=1:length(conf_mats)
    conf_path = [conf_dir '/' conf_mats(i).name];
    if ~exist(done_name,'file')
	    disp([conf_path ':']);
	    args = {conf_path, output_dir, mats_dir, output_extension};
		%try
		    improcdir(funcio,fileformat,1,input_dir,args);
		    save(done_name,'done_name');
		%catch exc_general
		%	fileID=fopen('errors.log','w');
		%	fprintf(fileID,['Error en ' conf_mats(i).name ':' getReport(exc_general)]);
		%	fclose(fileID);
		%end
     end



end


