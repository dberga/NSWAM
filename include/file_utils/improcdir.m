
function [] = improcdir(process,format,mode,input_path,args)

if(nargin < 5)
	directory = uigetdir(pwd, 'Select an input folder');           %get folder dir
    conf_path = uigetfile(pwd, 'Select a conf file');
    mats_folder = uigetdir(pwd, 'Select an mats folder');
    
    args = {conf_path,output_directory,mats_folder,'png'};
else
	directory = input_path;
end


files = dir(fullfile(directory, ['*.' format]));        %read files names
addpath(directory);                                     %add folder dir path
N_files = size(files,1);                                %readed number of files

%switch mode
    %case 1
    %    
    %    parfor i=1:N_files %parfor i=1:N_files
    %        disp(files(i).name); %files array with names
    %        img = imread(files(i).name);
    %        feval(process, files(i).name,img,args{1},args{2},args{3},args{4});
    %    end
        
    %otherwise
        for i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process, files(i).name,img,args{1},args{2},args{3},args{4});
        end
        
%end



end
