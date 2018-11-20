

function [] = run_big(input_dir, conf_dir, output_dir, mats_dir, fileformat,output_extension, funcio,flag_overwrite_log,flag_maxproc,email_logreport)

if nargin < 1, input_dir = 'input';end
if nargin < 2, conf_dir = 'conf/single'; end
if nargin < 3, output_dir = 'output'; end
if nargin < 4, mats_dir = 'mats'; end
if nargin < 5, fileformat = 'png'; end
if nargin < 6, output_extension = 'png'; end
if nargin < 7, funcio = 'nswam'; end
if nargin < 8, flag_overwrite_log=0; end
if nargin < 9, flag_maxproc=1; end
if nargin < 10, email_logreport='dberga@cvc.uab.es'; end

run(input_dir, conf_dir, output_dir, mats_dir, fileformat,output_extension, funcio,flag_overwrite_log,flag_maxproc,email_logreport);
    

end


