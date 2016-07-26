function [] = executa2(input_dir, conf_dir, fileformat, funcio)

if nargin < 1

input_dir = 'input_test';
conf_dir = 'conf_test';
fileformat = 'jpg';
funcio = 'saliency2';

end


%function dependencies
addpath('include/file_utils');
raddpath('include');

%NCZLd - Xavi/Xim/David
addpath('src');
addpath('src_mex');

conf_mats= dir(fullfile(conf_dir, ['*.mat']));

parfor i=1:length(conf_mats)
    conf_path = [conf_dir '/' conf_mats(i).name];
    improcdir(funcio,fileformat,1,input_dir,conf_path);
	
%IMPROCDIR IS:
%'saliency' = execute process 'saliency(...)' function 
%'jpg' = selected path asked by improcdir, load only images with format 'jpg'
%0 = for (1=parfor)

end

end

