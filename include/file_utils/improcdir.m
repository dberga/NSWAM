
function [] = improcdir(process,format,mode,input_path,args)

if(nargin < 5)
	directory = uigetdir(pwd, 'Select an input folder');           %get folder dir
    conf_path = uigetfile(pwd, 'Select a conf file');
    mats_folder = uigetdir(pwd, 'Select an mats folder');
    
    args = {conf_path,output_directory,mats_folder,'png'};
else
	directory = input_path;
    conf_path = args{1};
    output_directory=args{2};
    mats_folder=args{3};
    output_extension=args{4};
end


files = dir(fullfile(directory, ['*.' format]));        %read files names
addpath(directory);                                     %add folder dir path
N_files = size(files,1);                                %readed number of files

files=unsort_array(files);                              %unsort files to read

%switch mode
    %case 1
    %    
    %    parfor i=1:N_files %parfor i=1:N_files
    %        disp(files(i).name); %files array with names
    %        img = imread(files(i).name);
    %        feval(process, files(i).name,img,args{1},args{2},args{3},args{4});
    %    end
        
    %otherwise
    acum_error=[];
        result=0;
        for i=1:N_files
            disp(files(i).name); %files array with names
            img = imread(files(i).name);
            try
                feval(process,img,files(i).name,args{1},args{2},args{3},args{4});
            catch exc_process2
                result=-1;
                disp(getReport(exc_process2,'extended'));
                acum_error=[acum_error, '\n' ' error in config: ' conf_path];
                acum_error=[acum_error, '\n' ' error in image: ' files(i).name]; 
                acum_error=[acum_error, '\n' ' report: ' getReport(exc_process2,'extended')];
                continue;
            end
        end
        if result==-1
            error(acum_error);
        end
%end



end
