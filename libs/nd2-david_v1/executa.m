
%function dependencies
addpath('include/file_utils');
addpath('src');

raddpath('include');
%raddpath('libs');

%'saliency' = execute process 'saliency(...)' function 
%'jpg' = selected path asked by improcdir, load only images with format 'jpg'
%0 = iterative (1=in parallel)
improcdir('saliency','jpg',0);
