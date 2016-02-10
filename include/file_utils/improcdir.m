
function [] = improcdir(process,format,mode,input_path,args)

if(nargin < 4)
	directory = uigetdir(pwd, 'Select a folder');           %get folder dir
    args = [];
else
	directory = input_path;
end


files = dir(fullfile(directory, ['*.' format]));        %read files names
addpath(directory);                                     %add folder dir path
N_files = size(files,1);                                %readed number of files

switch mode
    case 0
        for i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process,img,files(i).name,args);
        end
    case 1
        parfor i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process,img, files(i).name,args);
        end
    otherwise
        for i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process,img,files(i).name,args);
        end
        
end



end
