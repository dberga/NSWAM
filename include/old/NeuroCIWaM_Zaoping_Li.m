function [img,img_out,imageoutname] = NeuroCIWaM_Zaoping_Li(img, niter, prec,str_name,updown,de,di,genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel)


t_ini=tic;

gamma=2.4; % No s'utilitza

Delta=25;

% plot (or not)
flag_plot=0;


% n_scales

switch multires
	case 'a_trous'
		n_scale_max=3;
	otherwise
		n_scale_max=2;
		
end

if(n_scales==0)
	n_scales=floor(log2(max(size(img(:,:,1))-1)))-n_scale_max;
end


% chromatic

%opp=rgb2opponentLM(img,gamma,0);
opp=rgb2opponent(img,gamma,0);

% sampling

if updown==0
   opp=opp(1:2:size(tmp,1),1:2:size(tmp,2),:); 
   img=img(1:2:size(tmp,1),1:2:size(tmp,2),:);
else
   %opp=kron(opp,ones(updown,updown));
   opp1=kron(squeeze(opp(:,:,1)),ones(updown,updown));
   opp2=kron(squeeze(opp(:,:,2)),ones(updown,updown));
   opp3=kron(squeeze(opp(:,:,3)),ones(updown,updown));
   opp=zeros(size(opp1,1),size(opp1,2),3);
   opp(:,:,1)=opp1;opp(:,:,2)=opp2;opp(:,:,3)=opp3;
   %img=uint8(kron(double(img),ones(updown,updown)));
   img1=uint8(kron(double(img(:,:,1)),ones(updown,updown)));
   img2=uint8(kron(double(img(:,:,2)),ones(updown,updown)));
   img3=uint8(kron(double(img(:,:,3)),ones(updown,updown)));
   img=zeros(size(img1,1),size(img1,2),3);
   img(:,:,1)=img1;img(:,:,2)=img2;img(:,:,3)=img3;
end    


% Zaoping_Li

im1=double(opp(:,:,1));
opp_out(:,:,1)=NeuroCIWaM_channel_Zaoping_Li(im1,niter,prec,de,di,genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0, 'chromatic',parallel);
im2=double(opp(:,:,2));
opp_out(:,:,2)=NeuroCIWaM_channel_Zaoping_Li(im2,niter,prec,de,di,genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0, 'chromatic',parallel);
im3=double(opp(:,:,3));
opp_out(:,:,3)=NeuroCIWaM_channel_Zaoping_Li(im3,niter,prec,de,di,genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0, 'intensity',parallel);

%img_out=opponentLM2rgb(opp_out,gamma,0);
img_out=opponent2rgb(opp_out,gamma,0);

% [gx_final,gy_final] = Qmodelinduction_v3_5(im,prec,niter,2,'mirror',de,di);
% %	Mean
% img_out=mean(gx_final(:,:,:,1:niter),4);


str_de1=num2str(de(1)); 
str_di1=num2str(di(1)); 
str_de2=num2str(de(2)); 
str_di2=num2str(di(2)); 
str_de3=num2str(de(3)); 
str_di3=num2str(di(3)); 
str_updown=num2str(updown);
str_ratio=num2str(de(1)/di(1));
str_delta=num2str(Delta);
%imageoutname=strcat('out_',str_name,'_',str_delta,'_',str_updown,'_',str_de,'_',str_di,'_',str_ratio);
imageoutname=strcat('out_',str_name,'_',str_delta,'_','sc1','_',str_de1,'_',str_di1,...
                        '_','sc1','_',str_de2,'_',str_di2,'_','sc1','_',str_de3,'_',str_di3);




if(parallel==0)
    
 % stimulus   
 %	figure,imshow(uint8(img),[]);
 % induced image
 % figure,imshow(uint8(img_out),[]);
    
    
    
%	figure,imshow(double(img)./max(max(max(double(img)))),[]);
%	figure,imshow(img_out./max(max(max(img_out))),[]);
	
%	figure,plot(img_out(size(img_out,1)/2,:,1));
%	figure,plot(img_out(size(img_out,1)/2,:,2));
%	figure,plot(img_out(size(img_out,1)/2,:,3));

% commented 11/11  
if flag_plot==1; 
    figure('Name',imageoutname),plot(img(round((size(img,2)/2)),:,1),'--b');hold on
    plot(img_out(round((size(img_out,2)/2)),:,1),'r');
end    


    %figure,plot(img(round((size(img,2)/2)),:,2),'--g');hold on
    %plot(img_out(round((size(img_out,2)/2)),:,2),'g');
    %figure,plot(img(round((size(img,2)/2)),:,3),'--b');hold on
    %plot(img_out(round((size(img_out,2)/2)),:,3),'b');
end



%imwrite(uint8(img_out),'imageoutname.ppm','PPM');
%iii=uint8(img_out);
%save(imageoutname,'iiii')
%mwrite(iiii,imageoutname,'JPEG')
%imageoutname=strcat('out_',str_name,'_',str_updown,'_',str_de,'_',str_di);
%imageoutname=strcat('out_',str_name,'_',str_delta,'_',str_updown,'_',str_de,'_',str_di);
save(imageoutname,'img_out')
%dif=double(img)-img_out;
%max(max(norm(dif(:,:,1))))
%max(max(norm(dif(:,:,2))))
%max(max(norm(dif(:,:,3))))




toc(t_ini)
end
