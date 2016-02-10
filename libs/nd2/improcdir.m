
function [] = improcdir(process)

directory = uigetdir(pwd, 'Select a folder');   %get folder dir
files = dir(fullfile(directory, '*.jpg'));      %read files names
addpath(directory);                             %add folder dir path
running = 1;                            %0 = iterative, 1 = in parallel
N_files = size(files,1);                %readed number of files

%iterative
if running == 0
    for i=1:N_files
        disp(files(i).name); %files array with names
        img = imread(files(i).name);
        feval(process,img,files(i).name);

    end
end


%in parallel
if running == 1
    parfor i=1:N_files
        disp(files(i).name); %files array with names
        img = imread(files(i).name);
        feval(process,img, files(i).name);
        
    end
end


end
