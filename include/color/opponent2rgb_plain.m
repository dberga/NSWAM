function img = opponent2rgb_plain(opp_img)

O12=opp_img(:,:,1);
O23=opp_img(:,:,2);
O3=opp_img(:,:,3);

img(:,:,3)=O3.*(1-O23)/3.0;
img(:,:,2)=(O3-img(:,:,3)-O3.*O12)*0.5;
img(:,:,1)=O3.*O12+img(:,:,2);

end