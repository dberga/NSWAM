function opp_img = rgb2opponent_plain(img)

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

O1 = R-G;
O2 = R+G-2*B;
O3 = R+G+B;

O13 = O1;
O23 = O2;

% For intensity-normalized chromatic channel
O13 = O1./O3;
O23 = O2./O3;

O13(isnan(O13)) = 0;
O23(isnan(O23)) = 0;

opp_img(:,:,1) = O13;
opp_img(:,:,2) = O23;
opp_img(:,:,3) = O3;

end
