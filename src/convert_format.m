

%addpath(genpath('/media/dberga/DATA/repos/NSWAM/include'));

h_limit=256;


%files_ext=dir('figures/qualitative/**/*.jpg');
files_ext=dir('figs/scanpaths/good/*.png');
% files_ext=dir('figures/topdown/psy/*.png');
for f=1:length(files_ext)
   [filefolder,filename,extension]=fileparts([files_ext(f).folder '/' files_ext(f).name]); 
   if isempty(filefolder),filefolder='.'; end
   disp([filefolder,'/',filename,'.',extension]);
   img=imread([filefolder,'/',filename,extension]);
   if size(img,1)>h_limit
       prop=size(img,2)/size(img,1);
       img=imresize(img,[h_limit round(h_limit*prop)]);
   end
   delete([filefolder,'/',filename,extension]);
   imwrite(img,[filefolder,'/',filename,'.jpg']);
end


