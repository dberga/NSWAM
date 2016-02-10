
function [] = improcdir(process,format,mode)

directory = uigetdir(pwd, 'Select a folder');           %get folder dir
files = dir(fullfile(directory, ['*.' format]));        %read files names
addpath(directory);                                     %add folder dir path
N_files = size(files,1);                                %readed number of files

switch mode
    case 0
        for i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process,img,files(i).name);
        end
    case 1
        parfor i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            feval(process,img, files(i).name);
        end
end



end
