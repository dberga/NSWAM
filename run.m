

function [] = executa(input_dir, conf_dir, output_dir, mats_dir, fileformat,output_extension, funcio,flag_overwrite_log,flag_maxproc,email_logreport)

if nargin < 1, input_dir = 'input';end
if nargin < 2, conf_dir = 'conf/single'; end
if nargin < 3, output_dir = 'output'; end
if nargin < 4, mats_dir = 'mats'; end
if nargin < 5, fileformat = 'png'; end
if nargin < 6, output_extension = 'png'; end
if nargin < 7, funcio = 'nswam'; end
if nargin < 8, flag_overwrite_log=0; end %set to 1 if you do not want the program to check for logs
if nargin < 9, flag_maxproc=0; end %set to 1 if you run several processes with same configuration
if nargin < 10, email_logreport='dberga@cvc.uab.es'; end %mail after finish or crash

%function dependencies
addpath('include/file_utils');
addpath(genpath('include'));
addpath('src');
addpath('src_mex');

%%init parpool
 %delete(gcp);
 %parpool('local',4);
 
 %read conf files
conf_mats= dir(fullfile(conf_dir, ['*.mat']));
conf_mats=unsort_array(conf_mats);

maxproc=1;
proc=1;
for i=1:length(conf_mats) %parfor i=1:length(conf_mats)
    log_name=[output_dir '/' 'log_' conf_mats(i).name '.txt'];
    done_name=[output_dir '/' 'done_' conf_mats(i).name '.txt'];
    error_name=[output_dir '/' 'error_' conf_mats(i).name '.txt'];
    
    conf_path = [conf_dir '/' conf_mats(i).name];
    
    if ~exist(done_name,'file') && (~exist(log_name,'file') || flag_overwrite_log) && ~exist(error_name,'file') && (proc<=maxproc || flag_maxproc)
 		try
            diary(log_name);
            diary on;
            
            disp([conf_path ':']);
            args = {conf_path, output_dir, mats_dir, output_extension};
		    improcdir(funcio,fileformat,1,input_dir,args);
            
            diary off;
            copyfile(log_name,done_name);
            
            smail(email_logreport,'completed',done_name);
            
  		catch exc_process
              diary off;
              copyfile(log_name,error_name);
              extendedreport=getReport(exc_process,'extended');
              append_text(error_name,extendedreport);
              disp(extendedreport);
              smail(email_logreport,extendedreport,error_name);
          end
        proc=proc+1;
        delete(log_name);
    end
    

end


