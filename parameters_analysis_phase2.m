%function z=parameters_analysis_phase2

% now, the de and di have length n_scale-1 (i.e. 4-1)
updown=[1];%,1,2];
% fast for test
%dedi=[60;90];
%dedi=[9,9,9,9,16,25,36;...
%     9,16,25,36,36,36,36];
%n_scales=4; % warning: defined twice!

% plot
plot_all=1;


niter=10;
prec=0.1;
%multires='a_trous';
multires='wav';
%multires='wav_contrast';
%multires='curv';
%multires='gabor';
n_scales=0; % El programa ho determina automaticament
%n_scales=5;
normal_input=4;
normal_output=2.0;
ON_OFF=0; % 0: separate, 1: abs, 2:square
nu_0=2;
parallel=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% general parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% "good" with B(:,:,1)=[8;12];
% genpar.kappa1=[0.3, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];  % e
% genpar.kappa2=[0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];  % i

genpar.kappa1=1.0*ones(1,10);  % e
genpar.kappa2=0.5*ones(1,10); % i



% genpar.kappa1=[0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];  % e
% genpar.kappa2=[0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];  % i

% genpar.kappa2=0.5*[0.3, 0.3, 0.3, 0.3, 0.2, 0.1];  % inh
% genpar.kappa1=[0.2, 0.2, 0.1, 0.1, 0.1, 0.1];  % exc

% genpar.kappa1=[0.3, 0.2, 0.2, 0.2, 0.2, 0.1];  % e
% genpar.kappa2=[0.3, 0.2, 0.2, 0.1, 0.1, 0.1];  % i


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% insert parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set n=0 for testing other parameters once
% a good set of dedi has been set

dedi=set_parameters_v1(1, multires);

% restriction
% dedi=dedi(:,43:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp=imread('White_effect_pattern_W2_256.ppm'); % aquest
str_name='White_effect_pattern_W2_256';
tmp1=tmp;str_name1=str_name;

% tmp=imread('F10.large_retall.ppm'); % aquest
% str_name='F10_large_retall';
% tmp1=tmp;str_name1=str_name;

%tmp=imread('White_effect_pattern_W2.ppm');
%str_name='White_effect_pattern_W2';
%tmp=imread('SBC_effect_pattern_SBC1_256.ppm');
%tmp=imread('SBC_effect_pattern_SBC3_256.ppm');
%tmp=imread('Todorovic_effect_pattern_T.ppm');
%str_name='Tod';

tmp=imread('Todorovic_effect_pattern_T_256.ppm');
str_name='Tod_256';
tmp2=tmp;str_name2=str_name;
% tmp=imread('F12.large_retall.ppm');
% str_name='F12_large_retall';
% tmp2=tmp;str_name2=str_name;

%tmp=imread('Todorovic_effect_pattern_T_512.ppm');
%str_name='Tod_512';
% tmp=imread('Chevreul_pattern.ppm');
% str_name='Chevreul_pattern';
% tmp3=tmp;str_name3=str_name;
tmp=imread('Mach_OP.ppm');
str_name='Mach_OP';
tmp3=tmp;str_name3=str_name;

tmp1=(double(tmp1)-128)*0.5+128;
tmp2=(double(tmp2)-128)*0.5+128;
tmp3=(double(tmp3)-128)*0.5+128;

% for ii=1:size(updown,2)
%     for jj=1:size(dedi,2)
%         %%%
%         [img1,img_out1,imageoutname1]=NeuroCIWaM_Zaoping_Li(tmp1,niter, prec,str_name1,updown(ii),dedi(1,jj,:),dedi(2,jj,:),genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel);
%         %%%
%         [img2,img_out2,imageoutname2]=NeuroCIWaM_Zaoping_Li(tmp2,niter, prec,str_name2,updown(ii),dedi(1,jj,:),dedi(2,jj,:),genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel);
%         %%%
%         [img3,img_out3,imageoutname3]=NeuroCIWaM_Zaoping_Li(tmp3,niter, prec,str_name3,updown(ii),dedi(1,jj,:),dedi(2,jj,:),genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel);
%         
%         
%         if plot_all==1
%             figure('Name',imageoutname1)
%             subplot(3,3,1),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
%             plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
%             %%%
%             subplot(3,3,2),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
%             plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
%             %%%
%             subplot(3,3,3),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
%             plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
% 
% 				subplot(3,3,4),imshow(uint8(img1));colormap('gray');
% 				subplot(3,3,5),imshow(uint8(img2)); colormap('gray');
% 				subplot(3,3,6),imshow(uint8(img3));colormap('gray');
% 				subplot(3,3,7),imshow(uint8(img_out1));colormap('gray');
% 				subplot(3,3,8),imshow(uint8(img_out2)); colormap('gray');
% 				subplot(3,3,9),imshow(uint8(img_out3));colormap('gray');
%        end
%     end
% end


% Only one image
%tmp=imread('Contrast_Yellow_Green_256.ppm');
%tmp=imread('Assimilacio_verd_blau_petit.ppm');
%tmp=imread('../hermann_ok.ppm');
tmp=imread('Mach_OP.ppm');
%tmp=imread('White_effect_pattern_W2_256.ppm');
%tmp=imread('../Todorovic_effect_pattern_T_256.ppm');
str_name='img';


[img1,img_out1,imageoutname1]=NeuroCIWaM_Zaoping_Li(tmp,niter, prec,str_name,updown(1),dedi(1,1,:),dedi(2,1,:),genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel);
figure('Name',imageoutname1)
subplot(3,1,1),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
subplot(3,1,2),imshow(uint8(img1));colormap('gray');
subplot(3,1,3),imshow(uint8(img_out1));colormap('gray');

figure,imshow(uint8(img_out1));


%end