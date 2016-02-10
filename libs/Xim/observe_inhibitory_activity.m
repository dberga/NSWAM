function []=observe_inhibitory_activity()
% [gop 19 12 2013]
% analyse inhibitory activity

load grating10_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ALL.mat
load grating10_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ON.mat
load grating10_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_OFF.mat

gy_final_ALLgr=gy_final_ALL;
gy_final_ONgr=gy_final_ON;
gy_final_OFgr=gy_final_OFF;

load natural128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ALL.mat
load natural128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ON.mat
load natural128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_OFF.mat

load branches128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ALL.mat
load branches128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_ON.mat
load branches128_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_INH_OFF.mat

% outputs are cells of size:
% n_membr x size(im,1) x size(im,2) x number of scales x number of
% orientations

% display activity
n_scales = 8;
if 1
			for s=1:min(2,n_scales) % define figures
				for o=1:4
					fig(s,o)=figure('Name',['s: ' int2str(s) ', o: ' int2str(o)]);
					pos=get(fig(s,o),'OuterPosition');
					set(fig(s,o),'OuterPosition',[0+(o-1)*pos(3) 0+(s-1)*pos(4) pos(3) pos(4)]);
				end
            end

            for tm=1:20 % n_membr  % plot dynamic
                for s=1:min(2,n_scales)
                    for o=1:4
                        figure(fig(s,o));subplot(1,3,1),imagesc(gy_final_ALL{tm}(:,:,s,o),[0 1]);colormap('gray');title('all inh');
                        figure(fig(s,o));subplot(1,3,2),imagesc(gy_final_ON{tm}(:,:,s,o));colormap('gray');title('inh on');
                        figure(fig(s,o));subplot(1,3,3),imagesc(gy_final_OFF{tm}(:,:,s,o),[0 1]);colormap('gray');title('inh off');
                    end
                end
            end % end n_mebr
end

% amount of energy diagnostic

for tm=1:20 % n_membr 
                     A{tm}=sum(sum(gy_final_ALLgr{tm}(:,:,:,:).^2,4),3);
                     Asum(tm)=sum(sum(A{tm}));
end

for tm=1:20,figure,imagesc(squeeze(A{tm}),[0,30]),end


for tm=1:20 % n_membr 
                     B{tm}=sum(sum(gy_final_ALL{tm}(:,:,:,:).^2,4),3);  
                     Bsum(tm)=sum(sum(B{tm}));
end

for tm=1:20,figure,imagesc(squeeze(B{tm}),[0,30]),end

figure,plot(Asum,'-k'),hold on
        plot(Bsum,'.-g')
        legend('grating','natural')

end