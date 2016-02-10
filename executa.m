
%function dependencies
addpath('include/file_utils');

%ciwam/swam
addpath('libs/SWAM_for_distro');
improcdir('saliency_naila','jpg',0);

%NCZLd
addpath('src');
raddpath('include');
improcdir('saliency','jpg',0);





%'saliency' = execute process 'saliency(...)' function 
%'jpg' = selected path asked by improcdir, load only images with format 'jpg'
%0 = iterative (1=in parallel)