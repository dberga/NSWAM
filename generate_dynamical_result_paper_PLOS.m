% generate the results for the dynamical case


%% computations
general_NCZLd;  % with the right options (compute.dynamic=1;)

    % stored in dynamic3_curv_final.mat

%% check the results
load dynamic3_curv.mat
load dynamic3_curv_final.mat

% load img
% load img_out
% load iFactor_ON
funcio_input=Mostrar_curv_video_POOL(curv,1,1,65/128,65/128);
funcio_output=Mostrar_curv_video_POOL(curv_final,1,1,65/128,65/128);
filtrada=imfilter(funcio_output,ones(1,30)');
figure,plot(filtrada),hold on, plot(funcio_input)

% the good plot

figure

a=min(filtrada);
b=max(filtrada);
normalize_arbitrary=a+(b-a)/2-0.035;
plot(normalize_arbitrary+0.09.*cos(2*pi.*(1:100)./100),'k','LineWidth',2)
hold on
plot(normalize_arbitrary.*ones(1,length(filtrada)),'--b','LineWidth',2)
hold on
plot(filtrada,'r','LineWidth',2)
hold on

legend('Luminance of the flanking areas','Luminance in the center area','Predicted brightness in the center area');
% ylim([0.1,0.45])



%save('curv_final_good_0_5Hz','curv_final')
%save('curv_good_0_5Hz','curv')

%%

load dynamic3_curv.mat
load dynamic3_curv_final.mat
scale=1;
Hz=0.50;
veure_contrafase(curv,scale,Hz)
veure_contrafase(curv_final,scale,Hz)


%% Below: from      preparatory_POSTER_FENS_2012_v2.m


% for counterphase poster FENS 2012



%% basic plots for illustrating Rossi and Paradiso

x1=(0:0.01:2*pi);
a=1.5;
sx=size(x1,2);
x2=a.*ones(1,sx);

% figure
% plot(x1,x2,'LineStyle','--','Color','k','LineWidth',2)
% ylim([0,3.5])
% hold on
% plot(x1,x2+sin(x1),'LineStyle','-','Color','k','LineWidth',2)


figure
plot(x1,x2,'--k','LineWidth',2)


hold on
plot(x1,x2+sin(x1),'k','LineWidth',2)
ylim([0,3.5])
set(gca, 'XTick', [])
set(gca, 'YTick', [])

figure
plot(x1,x2+sin(x1),'k','LineWidth',2)


hold on
plot(x1,x2+sin(-x1),'--k','LineWidth',2)
ylim([0,3.5])
set(gca, 'XTick', [])
set(gca, 'YTick', [])



%% counterphase 

load curv_final_good_1Hz
load curv_good_1Hz
% load img
% load img_out
% load iFactor_ON
funcio_input=Mostrar_curv_video_POOL(curv,1,1,65/128,65/128);
funcio_output=Mostrar_curv_video_POOL(curv_final,1,1,65/128,65/128);
filtrada=imfilter(funcio_output,ones(1,30)');
figure,plot(filtrada),hold on, plot(funcio_input)

% the good plot

figure

a=min(filtrada);
b=max(filtrada);
normalize_arbitrary=a+(b-a)/2-0.035;
plot(normalize_arbitrary+0.09.*cos(2*pi.*(1:100)./100),'k','LineWidth',2)
hold on
plot(normalize_arbitrary.*ones(1,length(filtrada)),'--b','LineWidth',2)
hold on
plot(filtrada,'r','LineWidth',2)
hold on

legend('Luminance of the flanking areas','Luminance in the center area','Predicted brightness in the center area');
ylim([0.1,0.45])

%% counterphase 4 Hz

load curv_final_good_4Hz
load curv_good_4Hz
% load img
% load img_out
% load iFactor_ON
funcio_input=Mostrar_curv_video_POOL(curv,1,1,65/128,65/128);
funcio_output=Mostrar_curv_video_POOL(curv_final,1,1,65/128,65/128);
filtrada=imfilter(funcio_output,ones(1,30)');
figure,plot(filtrada),hold on, plot(funcio_input)

% the good plot

figure

a=min(filtrada);
b=max(filtrada);
normalize_arbitrary=a+(b-a)/2-0.035;
plot(normalize_arbitrary+0.09.*cos(2*pi.*(1:100)./100),'k','LineWidth',2)
hold on
plot(normalize_arbitrary.*ones(1,length(filtrada)),'--b','LineWidth',2)
hold on
plot(filtrada,'r','LineWidth',2)
hold on

legend('Luminance of the flanking areas','Luminance in the center area','Predicted brightness in the center area');
ylim([0.1,0.45])



%save('curv_final_good_4Hz','curv_final')
%save('curv_good_4Hz','curv')

%% counterphase 0.5 Hz

load curv_final
load curv
% load img
% load img_out
% load iFactor_ON
funcio_input=Mostrar_curv_video_POOL(curv,1,1,65/128,65/128);
funcio_output=Mostrar_curv_video_POOL(curv_final,1,1,65/128,65/128);
filtrada=imfilter(funcio_output,ones(1,30)');
figure,plot(filtrada),hold on, plot(funcio_input)

% the good plot

figure

a=min(filtrada);
b=max(filtrada);
normalize_arbitrary=a+(b-a)/2-0.035;
plot(normalize_arbitrary+0.09.*cos(2*pi.*(1:100)./100),'k','LineWidth',2)
hold on
plot(normalize_arbitrary.*ones(1,length(filtrada)),'--b','LineWidth',2)
hold on
plot(filtrada,'r','LineWidth',2)
hold on

legend('Luminance of the flanking areas','Luminance in the center area','Predicted brightness in the center area');
ylim([0.1,0.45])



%save('curv_final_good_0_5Hz','curv_final')
%save('curv_good_0_5Hz','curv')


%% counterphase 

load curv_final_good_1Hz
load curv_good_1Hz
% load img
% load img_out
% load iFactor_ON
funcio_input=Mostrar_curv_video_POOL(curv,1,1,65/128,65/128);
funcio_output=Mostrar_curv_video_POOL(curv_final,1,1,65/128,65/128);
filtrada=imfilter(funcio_output,ones(1,12)');
figure,plot(filtrada),hold on, plot(funcio_input)

% the good plot

figure

a=min(filtrada);
b=max(filtrada);
normalize_arbitrary=a+(b-a)/2-0.035;
plot(normalize_arbitrary+0.09.*cos(2*pi.*(1:100)./100),'k','LineWidth',2)
hold on
plot(normalize_arbitrary.*ones(1,length(filtrada)),'--b','LineWidth',2)
hold on
plot(filtrada,'r','LineWidth',2)
hold on

legend('Luminance of the flanking areas','Luminance in the center area','Predicted brightness in the center area');
% ylim([0.1,0.45])
