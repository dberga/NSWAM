% load data  from  is_general_NCZLd_a_CSF.m
% but about contrast here!!!!! (fro sinusoidal gratings)

% Nota bene: 1 10 12: the two last figures are crucial !!! cf. below.


%load dynamic3_400_100tmembr_2Hz_flanks_20_curv.mat
%load dynamic3_400_100tmembr_2Hz_flanks_20_curv_final.mat
%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv.mat
%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv_final.mat

%load sinus_256_35_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_img.mat
%load sinus_256_35_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_img_out.mat

% stimuli
%name={'5','10','15','20','25','30','35','48','68','88','108','128'};
%frequencies=[5,10,15,20,25,30,35,48,68,88,108,128];
% name={'1','2','3','5','10','15','20','25','30','35','48','68','88','98','108','118','128'};
% frequencies=[1,2,3,5,10,15,20,25,30,35,48,68,88,98,108,118,128];

% now we add [7,9,11,13,17,19,23,27,39,43,53,59,65,77,83,91,103,107,113,123];
name={'1','2','3','5','7','9','10','11','13','15','17','19','20','23','25','27',...
   '30','39','43','48','53','59','65','68','77','83','88','91','98','103',...
   '107','108','113','118','123','128'};
frequencies=[1,2,3,5,7,9,10,11,13,15,17,20,23,25,27,30,35,39,43,48,53,59,65,...
           68,77,83,88,91,98,103,107,108,113,118,123,128];
% name={'1','2','3','5','7','9','10','11','13','15','17','19','20','23','25','27',...
%    '30','39','43','48','53','68','88','91','98','103',...
%    '108','118','128'};
% frequencies=[1,2,3,5,7,9,10,11,13,15,17,20,23,25,27,30,35,39,43,48,53,...
%            68,88,91,98,103,108,118,128];       
ratio=zeros(1,size(name,2));
ratio2=zeros(1,size(name,2));

% get the data
for i=1:size(name,2);
    name_in=strcat('sinus_256_',name{i},'_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_img.mat');
    name_out=strcat('sinus_256_',name{i},'_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_img_out.mat');
    load(name_in)
    load(name_out)
    img=squeeze(img(:,:,1));
    
    img_out_mean=mean(img_out,4);
    img_out_mean=squeeze(img_out_mean(:,:,1));
    %mitja_in(i)=mean(img(:));
    %mitja_out(i)=mean(img_out_mean(:));
    ratio(i)=(max(img_out_mean(:))-min(img_out_mean(:)))/(max(img(:))-min(img(:)));
    im1=img-mean(img(:));
    im2=img_out_mean-mean(img_out_mean(:));
    im1=abs(im1);
    im2=abs(im2);
    ratio_images=im2./im1;
    ratio_images(ratio_images==Inf)=0;
    ratio2(i)=mean(ratio_images(:));
    
    if i==6
        z=1;
    end    
%     figure%('Name',name_out)
%                         plot(img(round((size(img,2)/2)),:,1),'--b');hold on
%                         plot(img_out(round((size(img_out,2)/2)),:,1),'r');
%                         h=title('Brightness profile');set(h,'FontSize',16);
%                         legend('Visual stimulus','Predicted brightness');
%                         xlabel('# image column');
%                         ylabel('Brightness (arbitrary units)');
%     
end

figure;
plot(frequencies,ratio);

figure;
semilogx(frequencies,ratio);

figure;
semilogx(frequencies,ratio2);

figure;
semilogx(frequencies,1./ratio2);


% Nota bene: these are the two important figures since they show that our
% parameters are consistent with the the choice of weighting function by
% Blakeslee and McCourt (Vision Research 39, 1999, Fig. 1. (c)), which in
% turn is motivated by "the shallow low-frequency fall-off of the
% suprathreshold CSF that is expected to be associated with the
% high-contrast stimuli that are under inveestigation".

figure;loglog(frequencies,ratio)
robustdemo(log(frequencies),log(ratio))
  

figure;loglog(frequencies,ratio)
robustdemo(log2(frequencies),log2(ratio))
%figure
%plot(mitja_in,'r'),hold on
%plot(mitja_out,'g')

% % could be useful for a representation  
%   figure%('Name',name_out)
%                         plot(img(round((size(img,2)/2)),:,1),'--b');hold on
%                         plot(img_out(round((size(img_out,2)/2)),:,1),'r');
%                         h=title('Brightness profile');set(h,'FontSize',16);
%                         legend('Visual stimulus','Predicted brightness');
%                         xlabel('# image column');
%                         ylabel('Brightness (arbitrary units)');