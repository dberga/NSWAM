function [img,img_out] = NCZL(img,struct,n)

% time
t_ini=tic;

%-------------------------------------------------------
% make the structure explicit
wave=struct.wave;
image=struct.image;
display_plot=struct.display;

% struct.wave
multires=wave.multires;
n_scales=wave.n_scales;

% struct.image
gamma=image.gamma; % No s'utilitza
updown=image.updown;

%-------------------------------------------------------

% compute n_scales and store it in the structure
switch multires
	case 'a_trous'
		n_scale_max=3;
	otherwise
		n_scale_max=2;
end

if(n_scales==0)
	n_scales=floor(log2(max(size(img(:,:,1))-1)))-n_scale_max;
end
% store
wave.n_scales=n_scales;
% actualize struct
struct.wave=wave;

% opponent channels
opp=rgb2opponent(img,gamma,0);

% up/downsampling
if updown==0
   opp=opp(1:2:size(tmp,1),1:2:size(tmp,2),:); 
else
   opp1=kron(squeeze(opp(:,:,1)),ones(updown,updown));
   opp2=kron(squeeze(opp(:,:,2)),ones(updown,updown));
   opp3=kron(squeeze(opp(:,:,3)),ones(updown,updown));
   opp=zeros(size(opp1,1),size(opp1,2),3);
   opp(:,:,1)=opp1;opp(:,:,2)=opp2;opp(:,:,3)=opp3;
end    


% process channels separetely
im1=double(opp(:,:,1));
opp_out(:,:,1)=NCZL_channel(im1,struct,n,'chromatic');
im2=double(opp(:,:,2));
opp_out(:,:,2)=NCZL_channel(im2,struct,n,'chromatic');
im3=double(opp(:,:,3));
opp_out(:,:,3)=NCZL_channel(im3,struct,n,'intensity');

% output image (rgb values)
img_out=opponent2rgb(opp_out,gamma,0);

% time
toc(t_ini)
end
