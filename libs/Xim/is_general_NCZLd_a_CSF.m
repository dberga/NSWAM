% load data
%load dynamic3_400_100tmembr_2Hz_flanks_20_curv.mat
%load dynamic3_400_100tmembr_2Hz_flanks_20_curv_final.mat

%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv.mat
%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv_final.mat

load sinus_256_10_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_curv.mat
load sinus_256_10_min_freq_32_epsilon_1.1_kappay_1.5_normal_output_1.75_curv_final.mat

%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv.mat
%load nat1_256_min_freq_32_epsilon_1.3_kappay_1.5_normal_output_1.75_curv_final.mat


% frequencies
for i=1:size(curv,1)
    for s=1:4
        temp=curv{i}(:,:,s,:);
        %temp=temp(temp<0);
        temp=abs(temp);
        f_curv(i,s)=mean(temp(:));
        temp=curv_final{i}(:,:,s,:);
        %temp=temp(temp<0);
        temp=abs(temp);
        f_curv_final(i,s)=mean(temp(:));
    end
end    
 
 mean_f_curv=mean(f_curv,1);
 mean_f_curv_final=mean(f_curv_final,1);
 
 
  figure
  plot(mean_f_curv,'r')
  hold on
  plot(mean_f_curv_final,'g')
  
  figure
  plot(mean_f_curv_final./mean_f_curv)