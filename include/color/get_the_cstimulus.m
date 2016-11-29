function [tmp2]=get_the_cstimulus(tmp, gamma, srgb_flag)


if (ndims(tmp)==2) % Imatge B/N
	kk=tmp;
	tmp2(:,:,1)=kk;
	tmp2(:,:,2)=kk;
	tmp2(:,:,3)=kk;
	%disp('Imatge en B/N');
else
	%disp('Imatge en color');
    tmp2 = rgb2opponent_new(tmp,gamma,srgb_flag);
end

%tmp2=double(tmp2);
%tmp2=(tmp2-128)*0.75+128;

end


% 
% function [tmp2]=get_the_cstimulus(tmp)
% 
% 
% if (ndims(tmp)==2) % Imatge B/N
% 	kk=tmp;
% 	tmp2(:,:,1)=kk;
% 	tmp2(:,:,2)=kk;
% 	tmp2(:,:,3)=kk;
% 	disp('Imatge en B/N');
% else
% 	disp('Imatge en color');
% 	tmp2=tmp;
% end
% 
% % size(tmp2)
% 
% tmp2=double(tmp2);
% tmp2=(tmp2-128)*0.75+128;
% 
% end