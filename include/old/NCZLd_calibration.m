
% more off
% clear all
% close all
clear variables

% ===================================
% DEFINICIO PARAMETRES METODE
% ===================================
strct=get_default_parameters_NCZLd();

% Directory to work
%strct.compute.dir={'/home/xotazu/neuro/olivier/ZLi_model_for_induction_minimal_implementation_31_1_2011'};

% strct.wave.multires='wav_contrast';
% strct.zli.ini_scale=2;

strct.wave.n_scales=4;
n_scales=strct.wave.n_scales;

% zli.dedi=set_parameters_v2(2000, strct.wave.multires); % OP improve set_parameters



% zli.kappa1=1.0*ones(1,n_scales);  % e
% zli.kappa2=0.5*ones(1,n_scales);  % i
% zli.dedi=6*ones(2,n_scales);




strct.compute.factor_kappa=10;

% x0=[2.614138 0.770737 0.899369 0.514613 0.583354 0.252329 3.576255 0.834825 0.743150 0.690500 0.500669 3.931081];

% Versio 1
x0(1)=strct.zli.kappa1(1)*strct.compute.factor_kappa;
x0(2)=strct.zli.kappa2(1)*strct.compute.factor_kappa;
x0(3:3+n_scales-1)=strct.zli.dedi(1,1:n_scales);
x0(3+n_scales:3+n_scales+n_scales-1)=strct.zli.dedi(2,1:n_scales);
%x0=[15.513625 15.830895 29.938804 18.818254 28.655948 29.889573 29.459179 22.086692 10.874822 4.657473]

% Versio 2
% x0(1:n_scales)					=strct.zli.kappa1(1:n_scales)*strct.comp.factor_kappa;
% x0(n_scales+1:n_scales*2)	=strct.zli.kappa2(1:n_scales)*strct.comp.factor_kappa;
% x0(n_scales*2+1)				=strct.zli.dedi(1,1);
% x0(n_scales*2+2)				=strct.zli.dedi(2,1);



% Upper Bounds

% Versio 1
UB(1)=2*strct.compute.factor_kappa;
UB(2)=2*strct.compute.factor_kappa;
UB(3:3+n_scales+n_scales-1)=30*ones(1,n_scales*2);

% Versio 2
% UB(1:n_scales)					=2.0*ones(1,n_scales)*strct.comp.factor_kappa;
% UB(n_scales+1:n_scales*2)	=2.0*ones(1,n_scales)*strct.comp.factor_kappa;
% UB(n_scales*2+1)				=30;
% UB(n_scales*2+2)				=30;


% Lower Bounds


% Versio 1
LB(1)=0;
LB(2)=0;
LB(3:3+n_scales+n_scales-1)=2*ones(1,n_scales*2);

% Versio 2
% LB(1:n_scales)					=0*ones(1,n_scales)*strct.comp.factor_kappa;
% LB(n_scales+1:n_scales*2)	=0*ones(1,n_scales)*strct.comp.factor_kappa;
% LB(n_scales*2+1)				=2;
% LB(n_scales*2+2)				=2;


% ====================================
% PSYCHO DATA
% ====================================

grey_lsY=[0.66 0.98 27.5];
grey_LMS=lsY2LMS(grey_lsY);

black_lsY=grey_lsY;
black_lsY(:,3)=0.;

%Shevell circles colors
test_yellow_blue_lsY=[0.66 0.98 27.5];
test_green_blue_lsY=[0.67 1 26];
test_green_magenta_lsY=[0.66 0.98 27.5];
test_yellow_magenta_lsY=[0.65 1 30];
% Contrast colors
test_blue_green_contrast_lsY=[0.64 1 26];
test_green_yellow_contrast_lsY=[0.66 0.6 34.5];
test_yellow_magenta_contrast_lsY=[0.68 1 29.5];
test_magenta_blue_contrast_lsY=[0.66 1.4 21];

test_shevell_lsY=[0.62 1 20];
purple_lsY=[0.66 2 15];
lime_lsY=[0.66 0.16 15];


blue_lsY=[0.64 1.4 20];
yellow_lsY=[0.68 0.6 37];
green_lsY=[0.64 0.6 32];
magenta_lsY=[0.68 1.4 22];


psycho=[
0.660197	0.981026	26.270058;
0.654626	1.107513	24.104517;
0.649505	1.231424	23.291697;
0.672408	0.980160	24.839205;
0.675050	1.061771	24.183488;
0.673813	1.145942	23.905258;
0.661491	1.003175	26.463967;
0.665526	1.087157	25.297921;
0.668992	1.201087	23.528388;
0.646041	1.019085	28.521537;
0.643581	1.172555	27.177249;
0.641036	1.307224	24.955016;
0.650316	1.151510	22.783589;
0.650558	1.185329	22.388497;
0.649682	1.183782	22.524408;
0.645975	0.808994	27.568371;
0.643890	0.814822	26.452648;
0.641961	0.807008	26.813628;
0.669875	0.866857	31.430308;
0.670854	0.867217	31.322997;
0.671275	0.868406	31.473231;
0.670171	1.115540	26.537413;
0.669669	1.125146	27.618595;
0.669475	1.164695	27.112620;



0.656342 1.070865	22.655809;
0.656768	0.988966	24.685635;
0.658994	0.896722	25.021110;
0.672916	1.044096	22.909756;
0.676109	0.926769	24.094171;
0.679171	0.806152	24.392594;
0.664124	1.035406	24.496002;
0.665265	0.958763	25.345026;
0.663850	0.840190	25.741259;
0.643883	1.100656	24.065630;
0.644532	0.966051	25.241702;
0.645908	0.852683	25.691894

];


std_obsrv=[

0.002026	0.052031	2.572231;
0.004336	0.117753	2.368757;
0.008195	0.190102	3.083939;
0.002865	0.042194	1.207735;
0.004273	0.072240	2.418302;
0.005314	0.109056	1.753368;
0.003634	0.071464	2.321392;
0.003378	0.083528	2.357385;
0.004049	0.130750	3.110183;
0.003620	0.061694	2.754313;
0.003866	0.058140	1.991259;
0.005119	0.117433	2.159320;
0.002249	0.045267	1.666280;
0.003017	0.060351	1.194424;
0.002275	0.080340	0.842466;
0.002637	0.030687	1.836487;
0.005893	0.051165	1.366107;
0.004515	0.073100	1.711661;
0.002915	0.041164	1.756482;
0.002492	0.036989	1.853411;
0.003315	0.049205	1.392310;
0.003900	0.054552	1.363888;
0.002719	0.072893	0.821932;
0.002029	0.075587	1.327403;



0.001972	0.025264	1.259782;
0.002702	0.047608	1.010455;
0.001864	0.069675	0.909717;
0.002265	0.017377	0.770971;
0.003383	0.060659	0.847166;
0.004040	0.084041	0.597449;
0.001392	0.022065	1.003581;
0.001822	0.074640	0.695390;
0.002443	0.137085	0.567393;
0.002283	0.046945	1.067173;
0.002581	0.091019	1.024696;
0.002286	0.095669	1.042828

];



nstripes_experim=[5 11 17];
%erode_radi_experim=[5 2 2];
nstripes_masc_experim=[9 21 25];
placentral_experim=[4.357 3.357 2.357];

experiment(1).nom='Shevell 1';
experiment(1).stim_lsY=test_shevell_lsY;
str5=[0.5772 1.1539 22.0322];
str11=[0.5696 1.4410 27.1179];
str17=[0.5642 1.7248 27.3236];
experiment(1).test_lsY=cat(1,str5,str11,str17)
experiment(1).inductor_lsY=purple_lsY;
experiment(1).inductor_far_lsY=lime_lsY;

experiment(2).nom='Shevell 2';
experiment(2).stim_lsY=test_yellow_blue_lsY;
str5=[0.6599 0.9854 26.9660];
str11=[0.6537 1.1395 23.5124];
str17=[0.6492 1.2254 23.4334];
%experiment(2).test_lsY=cat(1,str5,str11,str17)
experiment(2).test_lsY=[psycho(1,:);psycho(2,:);psycho(3,:)];
experiment(2).inductor_lsY=blue_lsY;
experiment(2).inductor_far_lsY=yellow_lsY;

experiment(3).nom='Shevell 3';
experiment(3).stim_lsY=test_green_blue_lsY;
str5=[0.6723 0.9821 25.1396];
str11=[0.6784 1.0456 25.2572];
str17=[0.6759 1.1563 23.4140];
%experiment(3).test_lsY=cat(1,str5,str11,str17)
experiment(3).test_lsY=[psycho(4,:);psycho(5,:);psycho(6,:)];
experiment(3).inductor_lsY=blue_lsY;
experiment(3).inductor_far_lsY=green_lsY;

experiment(4).nom='Shevell 4';
experiment(4).stim_lsY=test_green_magenta_lsY;
str5=[0.6629 1.0185 26.7005];
str11=[0.6659 1.1051 24.2309];
str17=[0.6698 1.2441 23.7883];
%experiment(4).test_lsY=cat(1,str5,str11,str17)
experiment(4).test_lsY=[psycho(7,:);psycho(8,:);psycho(9,:)];
experiment(4).inductor_lsY=magenta_lsY;
experiment(4).inductor_far_lsY=green_lsY;

experiment(5).nom='Shevell 5';
experiment(5).stim_lsY=test_yellow_magenta_lsY;
str5=[0.6458 1.0066 29.5719];
str11=[0.6430 1.1975 27.4502];
str17=[0.6399 1.3259 24.1527];
%experiment(5).test_lsY=cat(1,str5,str11,str17)
experiment(5).test_lsY=[psycho(10,:);psycho(11,:);psycho(12,:)];
experiment(5).inductor_lsY=magenta_lsY;
experiment(5).inductor_far_lsY=yellow_lsY;

experiment(6).nom='Contrast 1';
experiment(6).stim_lsY=test_blue_green_contrast_lsY;
str5=[0.6489 1.1858 22.1650];
str11=[0.6507 1.2033 22.2219];
str17=[0.6498 1.2170 22.1628];
%experiment(6).test_lsY=cat(1,str5,str11,str17)
experiment(6).test_lsY=[psycho(13,:);psycho(14,:);psycho(15,:)];
experiment(6).inductor_lsY=green_lsY;
experiment(6).inductor_far_lsY=green_lsY;

experiment(7).nom='Contrast 2';
experiment(7).stim_lsY=test_green_yellow_contrast_lsY;
str5=[0.6451 0.7879 27.9652];
str11=[0.6439 0.8241 26.3306];
str17=[0.6412 0.7766 27.4971];
%experiment(7).test_lsY=cat(1,str5,str11,str17)
experiment(7).test_lsY=[psycho(16,:);psycho(17,:);psycho(18,:)];
experiment(7).inductor_lsY=yellow_lsY;
experiment(7).inductor_far_lsY=yellow_lsY;

experiment(8).nom='Contrast 3';
experiment(8).stim_lsY=test_yellow_magenta_contrast_lsY;
str5=[0.6659 0.9302 30.7611];
str11=[0.6717 0.8679 30.9819];
str17=[0.6730 0.8595 31.2594];
%experiment(8).test_lsY=cat(1,str5,str11,str17)
experiment(8).test_lsY=[psycho(19,:);psycho(20,:);psycho(21,:)];
experiment(8).inductor_lsY=magenta_lsY;
experiment(8).inductor_far_lsY=magenta_lsY;

experiment(9).nom='Contrast 4';
experiment(9).stim_lsY=test_magenta_blue_contrast_lsY;
str5=[0.6706 1.1195 26.9838];
str11=[0.6703 1.1314 27.8874];
str17=[0.6689 1.1752 27.7848];
%experiment(9).test_lsY=cat(1,str5,str11,str17)
experiment(9).test_lsY=[psycho(22,:);psycho(23,:);psycho(24,:)];
experiment(9).inductor_lsY=blue_lsY;
experiment(9).inductor_far_lsY=blue_lsY;

experiment(10).nom='Shevell2 2';
experiment(10).stim_lsY=test_yellow_blue_lsY;
str5=[0.6599 0.9854 26.9660];
str11=[0.6537 1.1395 23.5124];
str17=[0.6492 1.2254 23.4334];
%experiment(10).test_lsY=cat(1,str5,str11,str17)
experiment(10).test_lsY=[psycho(25,:);psycho(26,:);psycho(27,:)];
experiment(10).inductor_lsY=yellow_lsY;
experiment(10).inductor_far_lsY=blue_lsY;

experiment(11).nom='Shevell2 3';
experiment(11).stim_lsY=test_green_blue_lsY;
str5=[0.6723 0.9821 25.1396];
str11=[0.6784 1.0456 25.2572];
str17=[0.6759 1.1563 23.4140];
%experiment(11).test_lsY=cat(1,str5,str11,str17)
experiment(11).test_lsY=[psycho(28,:);psycho(29,:);psycho(30,:)];
experiment(11).inductor_lsY=green_lsY;
experiment(11).inductor_far_lsY=blue_lsY;

experiment(12).nom='Shevell2 4';
experiment(12).stim_lsY=test_green_magenta_lsY;
str5=[0.6629 1.0185 26.7005];
str11=[0.6659 1.1051 24.2309];
str17=[0.6698 1.2441 23.7883];
%experiment(12).test_lsY=cat(1,str5,str11,str17)
experiment(12).test_lsY=[psycho(31,:);psycho(32,:);psycho(33,:)];
experiment(12).inductor_lsY=green_lsY;
experiment(12).inductor_far_lsY=magenta_lsY;

experiment(13).nom='Shevell2 5';
experiment(13).stim_lsY=test_yellow_magenta_lsY;
str5=[0.6458 1.0066 29.5719];
str11=[0.6430 1.1975 27.4502];
str17=[0.6399 1.3259 24.1527];
%experiment(13).test_lsY=cat(1,str5,str11,str17)
experiment(13).test_lsY=[psycho(34,:);psycho(35,:);psycho(36,:)];
experiment(13).inductor_lsY=yellow_lsY;
experiment(13).inductor_far_lsY=magenta_lsY;



% ===================================

f=fopen('masc_stim_11.img','rb');
masc_stim_11=fread(f,512*640,'single');
masc_stim_11=reshape(masc_stim_11, 512, 640);
fclose(f);

f=fopen('masc_test_11.img','rb');
masc_test_11=fread(f,512*640,'single');
masc_test_11=reshape(masc_test_11, 512, 640);
fclose(f);


%for ipla=1:3
for ipla=3:3

    placentral=placentral_experim(ipla)
    
%    for iexperim=1:9
    for iexperim=2:13
%    for iexperim=1:1
    
        experiment(iexperim).nom
        
        stim_lsY=experiment(iexperim).stim_lsY
        inductor_lsY=experiment(iexperim).inductor_lsY
        inductor_far_lsY=experiment(iexperim).inductor_far_lsY

        
        
        for istripe=1:3
%        for istripe=3:3

            test_lsY=experiment(iexperim).test_lsY(istripe,:)
            
            nstripes=nstripes_experim(istripe)
%            erode_radi=erode_radi_experim(istripe)
            nstripes_masc=nstripes_masc_experim(istripe)






                % Crear imatge

                % lsY
                pic_stim=generate_colinduct_stim('shevell',inductor_lsY,inductor_far_lsY,stim_lsY,test_lsY,nstripes,grey_lsY,black_lsY);

                alcada=size(pic_stim,1);
                amplada=size(pic_stim,2);


                % Guardar imatge en disc

%                Nom=sprintf('stim_%d_%d_',iexperim,istripe)
%                EscriuRGB2BINReal(pic_stim,Nom);




%             % Mostrar/guardar resultats
%             f=fopen('Predictions_psycho.dat','at');
%             fprintf(f,'# %d stripes\n%f %f %f\n',nstripes,test_lsY(1),test_lsY(2),test_lsY(3));
%             fclose(f);
            
        end

    end
    
end



% ====================================

xdata11=[1,1];
xdata12=[1,2];
xdata13=[1,3];
xdata21=[2,1];
xdata22=[2,2];
xdata23=[2,3];
xdata31=[3,1];
xdata32=[3,2];
xdata33=[3,3];
xdata41=[4,1];
xdata42=[4,2];
xdata43=[4,3];
xdata51=[5,1];
xdata52=[5,2];
xdata53=[5,3];
xdata61=[6,1];
xdata62=[6,2];
xdata63=[6,3];
xdata71=[7,1];
xdata72=[7,2];
xdata73=[7,3];
xdata81=[8,1];
xdata82=[8,2];
xdata83=[8,3];
xdata91=[9,1];
xdata92=[9,2];
xdata93=[9,3];


% factor1=0.04;
% factor2=0.766;
% factor3=10.5;
factor1=1.;
factor2=1.;
factor3=1.;

factor=[factor1 factor2 factor3];

 ydata11=experiment(1).test_lsY(1,:)./factor;
 ydata12=experiment(1).test_lsY(2,:)./factor;
 ydata13=experiment(1).test_lsY(3,:)./factor;
 ydata21=experiment(2).test_lsY(1,:)./factor;
 ydata22=experiment(2).test_lsY(2,:)./factor;
 ydata23=experiment(2).test_lsY(3,:)./factor;
 ydata31=experiment(3).test_lsY(1,:)./factor;
 ydata32=experiment(3).test_lsY(2,:)./factor;
 ydata33=experiment(3).test_lsY(3,:)./factor;
 ydata41=experiment(4).test_lsY(1,:)./factor;
 ydata42=experiment(4).test_lsY(2,:)./factor;
 ydata43=experiment(4).test_lsY(3,:)./factor;
 ydata51=experiment(5).test_lsY(1,:)./factor;
 ydata52=experiment(5).test_lsY(2,:)./factor;
 ydata53=experiment(5).test_lsY(3,:)./factor;
 ydata61=experiment(6).test_lsY(1,:)./factor;
 ydata62=experiment(6).test_lsY(2,:)./factor;
 ydata63=experiment(6).test_lsY(3,:)./factor;
 ydata71=experiment(7).test_lsY(1,:)./factor;
 ydata72=experiment(7).test_lsY(2,:)./factor;
 ydata73=experiment(7).test_lsY(3,:)./factor;
 ydata81=experiment(8).test_lsY(1,:)./factor;
 ydata82=experiment(8).test_lsY(2,:)./factor;
 ydata83=experiment(8).test_lsY(3,:)./factor;
 ydata91=experiment(9).test_lsY(1,:)./factor;
 ydata92=experiment(9).test_lsY(2,:)./factor;
 ydata93=experiment(9).test_lsY(3,:)./factor;

%  ydata101=experiment(10).test_lsY(1,:)./factor;
%  ydata102=experiment(10).test_lsY(2,:)./factor;
%  ydata103=experiment(10).test_lsY(3,:)./factor;
%  ydata111=experiment(11).test_lsY(1,:)./factor;
%  ydata112=experiment(11).test_lsY(2,:)./factor;
%  ydata113=experiment(11).test_lsY(3,:)./factor;
%  ydata121=experiment(12).test_lsY(1,:)./factor;
%  ydata122=experiment(12).test_lsY(2,:)./factor;
%  ydata123=experiment(12).test_lsY(3,:)./factor;
%  ydata131=experiment(13).test_lsY(1,:)./factor;
%  ydata132=experiment(13).test_lsY(2,:)./factor;
%  ydata133=experiment(13).test_lsY(3,:)./factor;
% 

ydataCIWAM11=[0. 0. 0.];
ydataCIWAM12=[0. 0. 0.];
ydataCIWAM13=[0. 0. 0.];
ydataCIWAM21=[0. 0. 0.];
ydataCIWAM22=[0. 0. 0.];
ydataCIWAM23=[0. 0. 0.];
ydataCIWAM31=[0. 0. 0.];
ydataCIWAM32=[0. 0. 0.];
ydataCIWAM33=[0. 0. 0.];
ydataCIWAM41=[0. 0. 0.];
ydataCIWAM42=[0. 0. 0.];
ydataCIWAM43=[0. 0. 0.];
ydataCIWAM51=[0. 0. 0.];
ydataCIWAM52=[0. 0. 0.];
ydataCIWAM53=[0. 0. 0.];
ydataCIWAM61=[0. 0. 0.];
ydataCIWAM62=[0. 0. 0.];
ydataCIWAM63=[0. 0. 0.];
ydataCIWAM71=[0. 0. 0.];
ydataCIWAM72=[0. 0. 0.];
ydataCIWAM73=[0. 0. 0.];
ydataCIWAM81=[0. 0. 0.];
ydataCIWAM82=[0. 0. 0.];
ydataCIWAM83=[0. 0. 0.];
ydataCIWAM91=[0. 0. 0.];
ydataCIWAM92=[0. 0. 0.];
ydataCIWAM93=[0. 0. 0.];

% ydataCIWAM101=[0. 0. 0.];
% ydataCIWAM102=[0. 0. 0.];
% ydataCIWAM103=[0. 0. 0.];
% ydataCIWAM111=[0. 0. 0.];
% ydataCIWAM112=[0. 0. 0.];
% ydataCIWAM113=[0. 0. 0.];
% ydataCIWAM121=[0. 0. 0.];
% ydataCIWAM122=[0. 0. 0.];
% ydataCIWAM123=[0. 0. 0.];
% ydataCIWAM131=[0. 0. 0.];
% ydataCIWAM132=[0. 0. 0.];
% ydataCIWAM133=[0. 0. 0.];
% 

	% Shevell i contrast
xdata=[xdata21;xdata22;xdata23;xdata31;xdata32;xdata33;xdata41;xdata42;xdata43;xdata51;xdata52;xdata53;xdata61;xdata62;xdata63;xdata71;xdata72;xdata73;xdata81;xdata82;xdata83;xdata91;xdata92;xdata93]
ydata=[ydata21;ydata22;ydata23;ydata31;ydata32;ydata33;ydata41;ydata42;ydata43;ydata51;ydata52;ydata53;ydata61;ydata62;ydata63;ydata71;ydata72;ydata73;ydata81;ydata82;ydata83;ydata91;ydata92;ydata93]
%xdata=[xdata21;xdata22;xdata23;xdata31;xdata32;xdata33;xdata41;xdata42;xdata43;xdata51;xdata52;xdata53;xdata61;xdata62;xdata63;xdata71;xdata72;xdata73;xdata81;xdata82;xdata83;xdata91;xdata92;xdata93;xdata101;xdata102;xdata103;xdata111;xdata112;xdata113;xdata121;xdata122;xdata123;xdata131;xdata132;xdata133]
%ydata=[ydata21;ydata22;ydata23;ydata31;ydata32;ydata33;ydata41;ydata42;ydata43;ydata51;ydata52;ydata53;ydata61;ydata62;ydata63;ydata71;ydata72;ydata73;ydata81;ydata82;ydata83;ydata91;ydata92;ydata93;ydata101;ydata102;ydata103;ydata111;ydata112;ydata113;ydata121;ydata122;ydata123;ydata131;ydata132;ydata133]
	% Shevell
%xdata=[xdata21;xdata22;xdata23;xdata31;xdata32;xdata33;xdata41;xdata42;xdata43;xdata51;xdata52;xdata53]
%ydata=[ydata21;ydata22;ydata23;ydata31;ydata32;ydata33;ydata41;ydata42;ydata43;ydata51;ydata52;ydata53]

ydataCIWAM=[ydataCIWAM21;ydataCIWAM22;ydataCIWAM23;ydataCIWAM31;ydataCIWAM32;ydataCIWAM33;ydataCIWAM41;ydataCIWAM42;ydataCIWAM43;ydataCIWAM51;ydataCIWAM52;ydataCIWAM53;ydataCIWAM61;ydataCIWAM62;ydataCIWAM63;ydataCIWAM71;ydataCIWAM72;ydataCIWAM73;ydataCIWAM81;ydataCIWAM82;ydataCIWAM83;ydataCIWAM91;ydataCIWAM92;ydataCIWAM93]
param.placentral=2.357;
param.factor=factor;
param.ydata=ydata;

options=optimset('lsqcurvefit')


param.x0=x0;
param.ydata=ydata;
param.std_obsrv=std_obsrv;
param.strct=strct;

	param.ydata=ydata;
	
% CanviMin



%options=optimset(options,'MaxFunEvals',size(x0,2)*25,'DiffMaxChange',.5,'DiffMinChange',.01,'UseParallel','always')
options=optimset(options,'MaxFunEvals',size(x0,2)*25,'DiffMaxChange',10,'DiffMinChange',1)
%options=optimset(options,'MaxIter',1,'DiffMaxChange',.5,'DiffMinChange',.1)

system('touch inici_time.flag');
%x=lsqcurvefit(@(x,xdata) CIWaM(x,xdata,param),x0,xdata,ydataCIWAM,LB,UB,options)
x=lsqcurvefit(@(x,xdata) virtual_observer_func_parallel(x,param),x0,xdata,ydata,LB,UB,options)
% virtual_observer_func_parallel(x0,param)

system('touch fi_time.flag');
%CIWaM(x0,xdata,param);
