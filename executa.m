

function [] = executa(input_dir, conf_dir, output_dir, mats_dir, fileformat,output_extension, funcio)

if nargin < 1, input_dir = 'input';end
if nargin < 2, conf_dir = 'conf_try'; end
if nargin < 3, output_dir = 'output'; end
if nargin < 4, mats_dir = 'mats'; end
if nargin < 5, fileformat = 'jpg'; end
if nargin < 6, output_extension = 'png'; end
if nargin < 7, funcio = 'saliency'; end


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
 
 
diary_path='diary.txt';
diary(diary_path);

for i=1:length(conf_mats) %parfor i=1:length(conf_mats)
    done_name=[output_dir '/' 'log_' conf_mats(i).name '.txt'];
    error_name=[output_dir '/' 'error_' conf_mats(i).name '.txt'];
    conf_path = [conf_dir '/' conf_mats(i).name];
    if ~exist(done_name,'file')
	    disp([conf_path ':']);
	    args = {conf_path, output_dir, mats_dir, output_extension};
		try
            
		    improcdir(funcio,fileformat,1,input_dir,args);
            copyfile(diary_path,done_name);
            clc;
		    
		catch exc_general
            copyfile(diary_path,error_name);
            clc;
		end
     end



end


