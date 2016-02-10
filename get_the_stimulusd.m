function [tmpa,tmpb]=get_the_stimulusd(imsize,flanks_distance,stim)

w=(imsize-flanks_distance)/2;
part1=ceil(w);part2=floor(w);

switch(stim)
	case 1

% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,1
tmpa=uint8(128.*ones(imsize,imsize,3));
tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);

% tmpa(65,65,:)=128+58;

	case 2
% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,2
 tmpa=uint8(128.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);
 tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);

	case 3
% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,3
% from Figure 2.1 we add a central Gabor patch of a given frequency!!!
tmpa=uint8(128.*ones(imsize,imsize,3));
tmpb=uint8(100.*[ones(imsize,part1,3),zeros(imsize,flanks_distance,3),ones(imsize,part2,3)]);
load('gabor_patch_fig_2_3_128_1.mat') % Gabor patch ! :  figure;surf(a)
% load('gabor_patch_fig_2_3_64_1.mat') % Gabor patch ! :  figure;surf(a)
tmpa=tmpa+uint8(repmat(a,[1,1,3]));  % add the Gabor patch !

	case 4
% Rossi, Paradiso (J.Neurosci, 1999,19(4)), Figure 2,4 (switch a and b)
tmpa=uint8(128.*[ones(imsize,part1,3),ones(imsize,flanks_distance,3),ones(imsize,part2,3)]);
tmpb=uint8(100.*[zeros(imsize,part1,3),ones(imsize,flanks_distance,3),zeros(imsize,part2,3)]);


end



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