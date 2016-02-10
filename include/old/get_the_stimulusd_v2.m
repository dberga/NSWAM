function [tmpa,tmpb]=get_the_stimulusd_v2(imsize,flanks_distance)

% w=(imsize-flanks_distance)/2;
% part1=ceil(w);part2=floor(w);

% WARNING flanks_distance is the radius here !!!!!!!!!!!!!!!!!!!
flanks_distance=flanks_distance/2;


n=imsize;
fx=[ceil(-(n-1)/2):floor(n/2)];
fy=fx;
[fx,fy]=meshgrid(fx,fy);
f=sqrt(fx.^2+fy.^2);

% masks
%remove_c=1; % should be set adequately (remove dc and some low frequencies)
%remove_s=0; % should be set adequately (remove some high frequencies)
% better than the usual loop
center=ones(n,n);surround=center;
center(f>flanks_distance)=0;
surround(f>(floor(n/2)))=0;
surround(f<=flanks_distance)=0;
A=zeros(imsize,imsize,3);
A(:,:,1)=surround;A(:,:,2)=A(:,:,1);A(:,:,3)=A(:,:,1);
Z=center+surround;
ZZ=zeros(imsize,imsize,3);
ZZ(:,:,1)=Z;ZZ(:,:,2)=Z;ZZ(:,:,3)=Z;
tmpa=uint8(128.*ZZ);
tmpb=uint8(100.*A);


% add a Gabor patch

load('gabor_patch_fig_2_3_128_1.mat') % Gabor patch ! :  figure;surf(a)
tmpa=tmpa+uint8(repmat(a,[1,1,3]));  % add the Gabor patch !





% center

% surround

% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,1
%tmpa=uint8(128.*ones(imsize,imsize,3));
%tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);

% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,2
% tmpa=uint8(128.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);
% tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);

% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,4 (switch a and b)
% tmpa=uint8(128.*[ones(imsize,part1,3),ones(imsize,flanks_distance,3),ones(imsize,part2,3)]);
% tmpb=uint8(100.*[zeros(imsize,part1,3),ones(imsize,flanks_distance,3),zeros(imsize,part2,3)]);

% Pereverzeva Murray (JOV 2008) after Rossi, Paradiso (J.Neurosci,
% 1999,19(4)), Figure 2,1 Test gray level varies
% tmpa=128.*ones(imsize,imsize,3);
% test_varies=-128*(0/100);
% tmpa_modif=test_varies.*[zeros(imsize,part1,3),...
%                                     ones(imsize,flanks_distance,3),zeros(imsize,part2,3)];
% tmpa=uint8(tmpa+tmpa_modif);                                
% tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);
end


% im=uint8(128.*ones(256,256,3));
% ima=im;
% tempa=ima;
% imwrite(tempa,'ima.ppm','ppm')
% a=imread('ima.ppm');
% tempb=uint8(100.*[ones(256,100,3),zeros(256,56,3),ones(256,100,3)]);
% imwrite(tempb,'imb.ppm','ppm')
% a=imread('imb.ppm');
% figure:imshow(a)
% figure;surf(tmp(:,:,3,1))