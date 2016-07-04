img=imread('cameraman.tif');

canal=img(:,:,1);

figure,imshow (canal);

ampl=size(canal,2);
alc=size(canal,1);

nPlans=4;
[w c]=DWD_orient_undecimated(double(canal),nPlans);

% for i=1:nPlans
%     figure,imagesc(w{i}(:,:,1));colormap('gray');
%     figure,imagesc(w{i}(:,:,2));colormap('gray');
%     figure,imagesc(w{i}(:,:,3));colormap('gray');
%     figure,imagesc(c{i}/255);colormap('gray');
% end


w_out = NCZLd_mex(w);


for i=1:nPlans
    %figure,imagesc(w_out{i}(:,:,1));colormap('gray');
    %figure,imagesc(w_out{i}(:,:,2));colormap('gray');
    %figure,imagesc(w_out{i}(:,:,3));colormap('gray');
end


