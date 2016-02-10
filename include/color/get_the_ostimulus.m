function [tmp2]=get_the_ostimulus(tmp, gamma, srgb_flag)


if (ndims(tmp)==2) % Imatge B/N
	kk=tmp;
	tmp2(:,:,1)=kk;
	tmp2(:,:,2)=kk;
	tmp2(:,:,3)=kk;
	disp('Imatge en B/N');
else
	disp('Imatge en color');
    tmp2 = opponent2rgb_new(tmp,gamma,srgb_flag);
end


end

