function [ h ] = mosaic_figs( images_path, dims )


images_list=listpath(images_path);

if nargin<2, dims=1*length(images_list); end
    
imsize=[703 891];
mosaic = zeros(imsize(1),imsize(2),3,dims); 

mkdir([images_path '/montage']);
for i=1:length(images_list)
     image_path=[images_path '/' images_list{i}];
     
     img=imresize(imread(image_path),imsize);
     imwrite(img,[images_path '/montage' '/' images_list{i} ]);
     image_paths{i}=[images_path '/montage' '/' images_list{i} ];
end
h=montage(image_paths);

end

