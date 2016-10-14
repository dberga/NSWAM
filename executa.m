

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
raddpath('include');

%NCZLd - Xavi/Xim/David
addpath('src');
addpath('src_mex');

conf_mats= dir(fullfile(conf_dir, ['*.mat']));

for i=1:length(conf_mats)
    conf_path = [conf_dir '/' conf_mats(i).name];
    args = {conf_path, output_dir, mats_dir, output_extension};
    improcdir(funcio,fileformat,1,input_dir,args);
end


%IMPROCDIR IS:
%'saliency' = execute process 'saliency(...)' function 
%'jpg' = selected path asked by improcdir, load only images with format 'jpg'
%0 = for (1=parfor)

end


