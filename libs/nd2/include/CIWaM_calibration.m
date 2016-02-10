
% more off
% clear all
% close all

   % Colors LMS old

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


    % Colors LMS new

% grey_lsY=[0.659950 0.907590 27.577000];
% grey_LMS=lsY2LMS(grey_lsY);
% 
% % Shevell circles colors
% test_yellow_blue_lsY=[0.659950 0.907590 27.577000];
% test_green_blue_lsY=[0.669570 0.928590 25.983000];
% test_green_magenta_lsY=[0.659950 0.907590 27.577000];
% test_yellow_magenta_lsY=[0.650400 0.924170 30.184000];
% % Contrast colors
% test_blue_green_contrast_lsY=[0.640910	0,921990	26,247000];
% test_green_yellow_contrast_lsY=[0.659810 0.551100 34.634000];
% test_yellow_magenta_contrast_lsY=[0.679260 0.930820 29.380000];
% test_magenta_blue_contrast_lsY=[0.660100 1.302500 21.033000];
% 
% test_shevell_lsY=[0.622110	0.917660	20.326000];
% purple_lsY=[0.660320	1.868400	14.998000];
% lime_lsY=[0.659250 0.171300 15.124000];
% 
% 
% blue_lsY=[0.641030 1.295600 20.167000];
% yellow_lsY=[0.679090 0.552990 36.892000];
% green_lsY=[0.640780 0.549230 32.341000];
% magenta_lsY=[0.679430 1.309500 21.885000];






psycho=[

% Color LMS New

% 0.660137	0.908575	26.340733;
% 0.654852	1.025914	24.204800;
% 0.650018	1.140457	23.417467;
% 0.671893	0.910413	24.804133;
% 0.674486	0.988087	24.124400;
% 0.673327	1.067272	23.849933;
% 0.661391	0.929765	26.524600;
% 0.665297	1.009710	25.314333;
% 0.668685	1.118045	23.510467;
% 0.646643	0.941121	28.732000;
% 0.644356	1.083989	27.389400;
% 0.641987	1.209087	25.160000;
% 0.650751	1.066138	22.910400;
% 0.650993	1.097873	22.509467;
% 0.650157	1.096200	22.652733;
% 0.646511	0.744839	27.790133;
% 0.644543	0.750007	26.683333;
% 0.642709	0.742389	27.065867;
% 0.669402	0.803113	31.422067;
% 0.670345	0.803635	31.304800;
% 0.670755	0.804813	31.450000;
% 0.669787	1.037613	26.510467;
% 0.669303	1.046527	27.593200;
% 0.669133	1.083735	27.086533;

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

%0.637372	1.416097	20.386330;
%0.636562	1.409970	20.768008;
%0.644260	1.461082	20.333283;


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

% ===================================
% DEFINICIO PARAMETRES METODE


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

x0(1)=1.;     % fConstrastMaxMaxI
%x0(2)=0.;     % fContrastMaxMinI
x0(2)=2.;     % fSigmaMax1I
x0(3)=2.;     % fSigmaMax2I
%x0(4)=1.;     % fContrastMinMaxI
%x0(6)=1.;     % fContrastMinMinI
x0(4)=2.;     % fSigmaMin1I
%x0(6)=2.;     % fSigmaMin2I
x0(5)=1.;     % fOffSetMinI
x0(6)=1.;    % fOffsetChrom

x0(7)=1.;    % fContrastMaxChrom
x0(8)=2.;    % fSigmaMax1Chrom
x0(9)=2.;    % fSigmaMax2Chrom
x0(10)=2.;    % fOffSetMinChrom
%x0(14)=1.;    % fContrastMinChrom
x0(11)=1.;    % fSigmaMinChrom
x0(12)=2.;		% fPowNakaRushton
x0(13)=8;	% nScales


CanviMin=0.01

% Upper Bounds

UB(1)=2.0;		% fConstrastMaxMaxI
%UB(2)=2.5;		% fContrastMaxMinI
UB(2)=3.;		% fSigmaMax1I
UB(3)=3.;		% fSigmaMax2I
%UB(4)=1.0;		% fContrastMinMaxI
%UB(6)=2.0;		% fContrastMinMinI
UB(4)=3.;		% fSigmaMin1I
%UB(6)=4.;		% fSigmaMin2I
UB(5)=3.;		% fOffSetMinI
UB(6)=3.;		% fOffsetChrom
UB(7)=2.;      % fContrastMaxChrom
UB(8)=3.;      % fSigmaMax1Chrom
UB(9)=3.;		% fSigmaMax2Chrom
UB(10)=3.;		% fSigmaMinChrom
UB(11)=3.;		% fOffSetMinChrom
%UB(14)=2.;		% fContrastMinChrom
UB(12)=4.;		% fPowNakaRushton
%UB(13)=2.;		% fmatCanvi11
%UB(14)=2.;		% fmatCanvi12
%UB(15)=2.;		% fmatCanvi13
%UB(16)=2.;		% fmatCanvi21
%UB(17)=2.;		% fmatCanvi22
%UB(18)=2.;		% fmatCanvi23
%UB(19)=2.;		% fmatCanvi31
%UB(20)=2.;		% fmatCanvi32
%UB(21)=2.;		% fmatCanvi33
%UB(22)=2.;		% fmatCanvi41
%UB(23)=2.;		% fmatCanvi42
%UB(24)=2.;		% fmatCanvi43

UB(13)=CanviMin*100*16;

% Baixes_freq_zero tmp iContrast

UB(1)=3.0;		% fConstrastMaxMaxI
UB(2)=3.;		% fSigmaMax1I
UB(3)=3.;		% fSigmaMax2I
UB(4)=0.75;		% fFactor
UB(5)=2.;		% fOffSetMinI
UB(6)=2.;		% fOffsetChrom
UB(7)=3.0;     % fContrastMaxMaxChrom
UB(8)=3.;      % fSigmaMax1Chrom
UB(9)=3.;		% fSigmaMax2Chrom
UB(10)=0.75;		% fFactor
UB(11)=2.;		% fOffsetMinChrom
UB(12)=4.;		% fPowNakaRushton


% UB(1)=50.;		% fmatCanvi11
% UB(2)=50.;		% fmatCanvi12
% UB(3)=50.;		% fmatCanvi13
% UB(4)=50.;		% fmatCanvi22
% UB(5)=50.;		% fmatCanvi22
% UB(6)=50.;		% fmatCanvi23
% UB(7)=50.;		% fmatCanvi31
% UB(8)=50.;		% fmatCanvi32
% UB(9)=50.;		% fmatCanvi33
% UB(10)=50.;		% fmatCanvi41
% UB(11)=50.;		% fmatCanvi42
% UB(12)=50.;		% fmatCanvi43

% UB(1)=4.
% UB(2:26)=3.

% Lower Bounds
% LB(1)=1.
% LB(2:26)=0.

LB(1)=1.0;		% fConstrastMaxMaxI
%LB(2)=0.;		% fContrastMaxMinI
LB(2)=0.25;		% fSigmaMax1I
LB(3)=0.25;		% fSigmaMax2I
%LB(4)=1.0;		% fContrastMinMaxI
%LB(6)=0.9;		% fContrastMinMinI
LB(4)=0.25;		% fSigmaMin1I
%LB(6)=0.5;		% fSigmaMin2I
LB(5)=-1.0; 	% fOffSetMinI
LB(6)=-1.0; 	% fOffsetChrom
LB(7)=1.0;		% fContrastMax1Chrom
LB(8)=0.25; 	% fSigmaMax1Chrom
LB(9)=0.25; 	% fContrastMinChrom
LB(10)=0.5; 	% fSigmaMinChrom
LB(11)=-1.0;	% fOffSetMinChrom
%LB(14)=0.9;		% fContrastMinChrom
LB(12)=1.0;		% fPowNakaRushton
%LB(13)=-2.;		% fmatCanvi11
%LB(14)=-2.;		% fmatCanvi12
%LB(15)=-2.;		% fmatCanvi13
%LB(16)=-2.;		% fmatCanvi21
%LB(17)=-2.;		% fmatCanvi22
%LB(18)=-2.;		% fmatCanvi23
%LB(19)=-2.;		% fmatCanvi31
%LB(20)=-2.;		% fmatCanvi32
%LB(21)=-2.;		% fmatCanvi33
%LB(22)=-2.;		% fmatCanvi41
%LB(23)=-2.;		% fmatCanvi42
%LB(24)=-2.;		% fmatCanvi43

LB(13)=CanviMin*100*4;


% Baixes_freq_zero tmp iContrast

LB(1)=1.0;		% fConstrastMaxMaxI
LB(2)=0.1;		% fSigmaMax1I
LB(3)=0.1;		% fSigmaMax2I
LB(4)=0.1;		% fFactor
LB(5)=-1.0;		% fOffSetMinI
LB(6)=-1.;		% fOffsetChrom
LB(7)=1.;      % fContrastMaxMaxChrom
LB(8)=0.1;    % fSigmaMax1Chrom
LB(9)=0.1;		% fSigmaMax2Chrom
LB(10)=0.1;		% fFactor
LB(11)=-1.;		% fOffsetMinChrom
LB(12)=.5;		% fPowNakaRushton




% LB(1)=-50.;		% fmatCanvi11
% LB(2)=-50.;		% fmatCanvi12
% LB(3)=-50.;		% fmatCanvi13
% LB(4)=-50.;		% fmatCanvi21
% LB(5)=-50.;		% fmatCanvi22
% LB(6)=-50.;		% fmatCanvi23
% LB(7)=-50.;		% fmatCanvi31
% LB(8)=-50.;		% fmatCanvi32
% LB(9)=-50.;		% fmatCanvi33
% LB(10)=0.;		% fmatCanvi41
% LB(11)=0.;		% fmatCanvi42
% LB(12)=0.;		% fmatCanvi43

% Direct sampling divisive norm
for i=1:20
	UB(i)=10.;
	LB(i)=0.001;
end

UB(21)=10;
LB(21)=1;

% xdata11=[experiment(1).stim_lsY,experiment(1).inductor_lsY,experiment(1).inductor_far_lsY,1,1]
% xdata12=[experiment(1).stim_lsY,experiment(1).inductor_lsY,experiment(1).inductor_far_lsY,1,2]
% xdata13=[experiment(1).stim_lsY,experiment(1).inductor_lsY,experiment(1).inductor_far_lsY,1,3]
% xdata21=[experiment(2).stim_lsY,experiment(2).inductor_lsY,experiment(2).inductor_far_lsY,2,1]
% xdata22=[experiment(2).stim_lsY,experiment(2).inductor_lsY,experiment(2).inductor_far_lsY,2,2]
% xdata23=[experiment(2).stim_lsY,experiment(2).inductor_lsY,experiment(2).inductor_far_lsY,2,3]
% xdata31=[experiment(3).stim_lsY,experiment(3).inductor_lsY,experiment(3).inductor_far_lsY,3,1]
% xdata32=[experiment(3).stim_lsY,experiment(3).inductor_lsY,experiment(3).inductor_far_lsY,3,2]
% xdata33=[experiment(3).stim_lsY,experiment(3).inductor_lsY,experiment(3).inductor_far_lsY,3,3]
% xdata41=[experiment(4).stim_lsY,experiment(4).inductor_lsY,experiment(4).inductor_far_lsY,4,1]
% xdata42=[experiment(4).stim_lsY,experiment(4).inductor_lsY,experiment(4).inductor_far_lsY,4,2]
% xdata43=[experiment(4).stim_lsY,experiment(4).inductor_lsY,experiment(4).inductor_far_lsY,4,3]
% xdata51=[experiment(5).stim_lsY,experiment(5).inductor_lsY,experiment(5).inductor_far_lsY,5,1]
% xdata52=[experiment(5).stim_lsY,experiment(5).inductor_lsY,experiment(5).inductor_far_lsY,5,2]
% xdata53=[experiment(5).stim_lsY,experiment(5).inductor_lsY,experiment(5).inductor_far_lsY,5,3]
% xdata61=[experiment(6).stim_lsY,experiment(6).inductor_lsY,experiment(6).inductor_far_lsY,6,1]
% xdata62=[experiment(6).stim_lsY,experiment(6).inductor_lsY,experiment(6).inductor_far_lsY,6,2]
% xdata63=[experiment(6).stim_lsY,experiment(6).inductor_lsY,experiment(6).inductor_far_lsY,6,3]
% xdata71=[experiment(7).stim_lsY,experiment(7).inductor_lsY,experiment(7).inductor_far_lsY,7,1]
% xdata72=[experiment(7).stim_lsY,experiment(7).inductor_lsY,experiment(7).inductor_far_lsY,7,2]
% xdata73=[experiment(7).stim_lsY,experiment(7).inductor_lsY,experiment(7).inductor_far_lsY,7,3]
% xdata81=[experiment(8).stim_lsY,experiment(8).inductor_lsY,experiment(8).inductor_far_lsY,8,1]
% xdata82=[experiment(8).stim_lsY,experiment(8).inductor_lsY,experiment(8).inductor_far_lsY,8,2]
% xdata83=[experiment(8).stim_lsY,experiment(8).inductor_lsY,experiment(8).inductor_far_lsY,8,3]
% xdata91=[experiment(9).stim_lsY,experiment(9).inductor_lsY,experiment(9).inductor_far_lsY,9,1]
% xdata92=[experiment(9).stim_lsY,experiment(9).inductor_lsY,experiment(9).inductor_far_lsY,9,2]
% xdata93=[experiment(9).stim_lsY,experiment(9).inductor_lsY,experiment(9).inductor_far_lsY,9,3]


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

% xdata101=[10,1];
% xdata102=[10,2];
% xdata103=[10,3];
% xdata111=[11,1];
% xdata112=[11,2];
% xdata113=[11,3];
% xdata121=[12,1];
% xdata122=[12,2];
% xdata123=[12,3];
% xdata131=[13,1];
% xdata132=[13,2];
% xdata133=[13,3];


factor1=0.04;
factor2=0.766;
factor3=10.5;

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
%ydataCIWAM=[ydataCIWAM21;ydataCIWAM22;ydataCIWAM23;ydataCIWAM31;ydataCIWAM32;ydataCIWAM33;ydataCIWAM41;ydataCIWAM42;ydataCIWAM43;ydataCIWAM51;ydataCIWAM52;ydataCIWAM53;ydataCIWAM61;ydataCIWAM62;ydataCIWAM63;ydataCIWAM71;ydataCIWAM72;ydataCIWAM73;ydataCIWAM81;ydataCIWAM82;ydataCIWAM83;ydataCIWAM91;ydataCIWAM92;ydataCIWAM93;ydataCIWAM101;ydataCIWAM102;ydataCIWAM103;ydataCIWAM111;ydataCIWAM112;ydataCIWAM113;ydataCIWAM121;ydataCIWAM122;ydataCIWAM123;ydataCIWAM131;ydataCIWAM132;ydataCIWAM133]

%xdata=[xdata21;xdata22];
%ydata=[ydata21;ydata22];

%param.experiment=experiment;
param.placentral=2.357;
%param.placentral=1.357;
%param.amplada=amplada;
%param.alcada=alcada;
param.factor=factor;
param.ydata=ydata;

options=optimset('lsqcurvefit')

DiffMaxChange(1)=.5;     % fConstrastMaxMaxI
DiffMaxChange(2)=.5;     % fContrastMaxMinI
DiffMaxChange(3)=.5;     % fSigmaMax1I
DiffMaxChange(4)=.5;     % fSigmaMax2I
DiffMaxChange(5)=.5;     % fContrastMinMaxI
DiffMaxChange(6)=.5;     % fContrastMinMinI
DiffMaxChange(7)=.5;     % fSigmaMin1I
DiffMaxChange(8)=.5;     % fSigmaMin2I
DiffMaxChange(9)=.5;     % fOffSetMinI
DiffMaxChange(10)=.5;    % fOffsetChrom
DiffMaxChange(11)=.5;    % fContrastMaxChrom
DiffMaxChange(12)=.5;    % fSigmaMaxChrom
% DiffMaxChange(13)=.5;    % fOffSetMinChrom
% DiffMaxChange(14)=.5;    % fContrastMinChrom
% DiffMaxChange(15)=.5;    % fSigmaMinChrom

%DiffMinChange(1)=.1;     % fConstrastMaxMaxI
%DiffMinChange(2)=.1;     % fContrastMaxMinI
%DiffMinChange(3)=.1;     % fSigmaMax1I
%DiffMinChange(4)=.1;     % fSigmaMax2I
%DiffMinChange(5)=.1;     % fContrastMinMaxI
%DiffMinChange(6)=.1;     % fContrastMinMinI
%DiffMinChange(7)=.1;     % fSigmaMin1I
%DiffMinChange(8)=.1;     % fSigmaMin2I
%DiffMinChange(9)=.1;     % fOffSetMinI
%DiffMinChange(10)=.1;    % fOffsetChrom
%DiffMinChange(11)=.1;    % fContrastMaxChrom
%DiffMinChange(12)=.1;    % fSigmaMaxChrom
% DiffMinChange(13)=.1;    % fOffSetMinChrom
% DiffMinChange(14)=.1;    % fContrastMinChrom
% DiffMinChange(15)=.1;    % fSigmaMinChrom

%x0=[0.9164    0.0000    0.9834    1.0202    0.0011    0.0419    0.9048    0.6025    1.1176    0.1433    0.1179    3.4858   -0.5433    0.0260    3.1667]
%x0=[0.947834 0.000000 0.964557 1.090654 0.988160 0.916897 0.902611 0.635128 1.138247 0.142785 0.938721 3.487885 -0.545033 0.925839 3.169607]
%x0=[2.170924 0.000000 0.902626 1.098094 1.252750 0.900000 0.695662 0.541232 0.932174 1.035864 0.201189 2.349746 0.800563 0.901258 1.750082]
%x0=[2.3231    0.0000    0.8274    0.9541    1.4266    0.9000    0.5000    0.5188    0.6469    0.9415    0.7635    2.0424    0.7976    0.9007    1.2400];
%x0=[2.4930    0.0000    0.7645    0.8816    1.7609    0.9000    0.5000    0.5002    0.7083    0.6615    1.9802    1.2719    0.5131    0.9000    0.6521];
%x0=[2.2137    1.0791    1.7741    1.0000    0.5899    2.0000    0.7212    1.2603    2.2192    1.5782    1.0445    1.2960];
%x0=[1.9401    1.5956    1.9149    0.8645    0.7574    1.6453    1.5608    1.5420    1.7434    1.4051];
%x0=[1.9984    0.9475    1.1379    0.6179    0.6441    1.2981    1.7018    1.6179    1.2343    1.4326		2.0];
%x0=[2.0000    1.0541    0.9656    0.5627    0.6761    0.8505    0.2024    1.8323    0.7010    1.4246    3.2302];
%x0=[2.436935 0.914068 0.818520 0.502320 0.667510 0.491920 0.405865 2.150723 0.446695 1.485111 3.805951];

%x0=[2.4373    0.9139    0.8187    0.5023    0.6654    0.4921    0.4058    1.1508    0.4469    1.4851    3.8064];
%x0=[2.455720 0.903352 0.823334 0.501360 0.557983 0.537781 0.425887 1.165895 0.488167 1.485100 3.83173];

% OK
%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    1.4332    1.1614    0.4876    1.4836    3.8363];

%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    1.8332    0.8614    0.4876    1.4836    3.8363];

%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    3.0332    1.8614    0.5000	0.6876    0.4836    3.9000];
x0=[2.614138 0.770737 0.899369 0.514613 0.583354 0.252329 3.576255 0.834825 0.743150 0.690500 0.500669 3.931081];
x0=[3.607545 1.491439 1.094023 1.113381 0.195946 0.171100 3.957834 0.336908 0.520858 0.992906 0.960383 4.953779 ]; % Temporal
x0=[3.939022 1.526633 1.160991 0.936230 0.962031 0.162738 3.947664 0.567548 0.724953 1.033168 0.890329 4.985301]; % Ok virtual_observer
x0=[3.939022 1.526633 1.160991 0.936230 0.962031 0.002738 3.947664 0.567548 0.824953 0.833168 0.890329 4.985301];	% OK virtual_observer retocat

x0=[3.9989   0.5001   2.0000   0.5096   1.6829   0.6282   4.0000   1.1151   0.6825   0.5126   0.7295   1.5003]; % tmp OK

x0=[1.9989   0.5001   1.5000   0.5096   1.0829   0.6282   2.0000   1.1151   0.6825   0.5126   0.5295   3.05003]; % exp

x0=[1.199916 2.000000 1.612948 1.051123 0.000000 0.814826 1.193873 3.762478 0.957792 0.002925 0.679767 4.999993]; % exp OK
x0=[1.390000 1.990000 0.685166 0.500379 0.614276 0.172343 1.390000 1.111062 0.735379 0.000066 0.421451 4.990000];
x0=[1.390000 1.990000 0.685166 0.500379 0.614276 0.172343 1.390000 1.111062 0.735379 0.000066 0.421451 4.990000 0.9 -0.1 0.1 0.9 0. 0.];


x0=[1.399726 1.999490 1.294564 1.131984 0.062529 0.857701 1.399384 3.702321 0.795964 0.000004 0.767572 4.999615 1.803492 0.474138 0.027097 -0.341491 -1.198164 -0.759501]; % tmp

x0superf=[1.390000 2.000000 0.685166 0.500379 0.614276 0.172343 1.390000 1.111062 0.735379 0.000066 0.421451 5.];
x0superf=[3.939022 1.526633 1.160991 0.936230 0.962031 0.002738 3.947664 0.567548 0.824953 0.833168 0.890329 4.985301]; % OK
x0superf_VR=[2.406462 0.788439 0.838273 0.993372 0.770077 0.024683 3.971177 0.941022 1.440777 0.306167 0.590519 4.999668]; % OK

x0superf=[4.465110 2.694566 2.911223 1.169708 -0.047523 0.202832 3.937413 0.777669 0.438117 -0.269273 0.329458 5.004990]; % tmp !!!

%x0superf=[2.329674 0.761278 0.867601 0.959346 0.855962 0.024191 3.968569 1.025528 1.413389 0.286156 0.654456 4.958718]; % tmp !!!

%x0superf=[6.519185 9.206476 -14.083580 -0.852091 1.178954 -0.756488 3.573379 -0.285192 -1.613760 -14.001402 0.736594 8.139386]; % tmp per iContrast
%x0superf=[4.984150 2.984769 1.424479 1.542736 0.760388 0.032856 4.197551 0.582690 0.655625 -0.493917 0.110794 5.962706 ];% tmp per iContrast

%x0superf=[2.0 1.0 1.0 1.5 1.0 0.0 2.0 0.5 0.5 0.0 0.1 2.0 ];% tmp per iContrast
x0superf=[4.694863 2.960874 1.017597 1.004582 -0.029451 0.449422 3.410797 0.102907 1.379384 0.808772 0.234170 5.969737];% iContrast


%x0superf_VR=[1.0 1.25 1.25 1.25 0. 2. 1. 2. 1.25 2. 2. 2.];


x0superf_VR=[1.0 2.0 1.25 2.0 2.0     0.0 2.5 2.0 1.25 1.0 1.0		2.0];

x0superf_VR=[0.761958 1.809510 1.294948 1.917020 1.949195 -0.049436 2.200994 1.653206 1.910503 0.875267 2.415895 1.343111];	% tmp Curvelets
x0superf_VR=[3.438770 0.343833 2.903926 1.183748 2.433725 0.186026 2.223981 0.541529 2.864874 0.490733 2.097745 1.293632];	% tmp Curvelets

x0superf_VR=[4.522534 0.326329 2.978547 0.370184 2.383625 0.260314 2.579860 0.475874 2.745886 0.429925 2.156648 1.017377 ];	% tmp Curvelets
x0superf_VR=[4.897553 0.273593 2.999724 0.384161 2.214932 1.444764 2.920200 1.399688 3.518296 0.276469 2.021938 1.000848];	% lsY Curvelets

%x0superf_VR=[4.897553 0.273593 2.999724 0.384161 2.214932 1.444764 2.920200 1.399688 3.518296 0.276469 2.021938 1.000848 8.0];	% lsY Curvelets


x0superf_VR=[4.997000 1.410625 2.999724 0.384161 0.925747 2.271270 3.375408 1.699085 0.972288 0.222951 2.631629 1.015582];	% ls Curvelets

x0superf_VR=[4.997000 1.410625 2.999724 0.384161 0.925747 2.271270 3.375408 1.699085 0.972288 0.222951 2.631629 1.015582 8.000000]; % ls Curvelets nangles


x0superf_iContrast=[4.694863 2.960874 1.017597 1.004582 -0.029451 0.449422 3.410797 0.102907 1.379384 0.808772 0.234170 5.969737];% iContrast


%x0superf_VR=[1.0 1.25 1.25 2.0 2.0 2.0 1.0 2.0 1.25 2.0 2.0 2.0]; % JIST_MODIF
%x0superf_VR=[1.0 2.0 4.0 2.0 0.0 2.0 1.0 2.0 4.0 2.0 2.0 2.0]; % JIST

 x0superf_VR=[1.0 1.25 1.25 2.0 2.0 1.0 1.0 2.0 1.25 2.0 1.0 2.0]; % JIST_MODIF v1
 x0superf_VR=[1.0 1.25 1.25 2.0 2.0 1.0 2.0 2.0 1.25 2.0 2.0 2.0]; % JIST_MODIF v2
 x0superf_VR=[1.0 1.25 1.25 2.0 2.0 1.0 2.0 2.75 0.9 0.5 0.25 4.0]; % JIST_MODIF v2 tmp
 x0superf_VR=[2.0 2.25 1.50 1.0 0.0 1.0 2.0 2.75 0.9 0.5 0.25 4.0]; % JIST_MODIF v2 tmp2
 x0superf_VR=[2.0 2.90 1.25 0.5 -0.3 1.4 2.0 2.93 0.6 0.57 0.05 4.0]; % JIST_MODIF v2 tmp3

 x0superf_VR=[2.0 3.0 2.8 0.5 -0.3 1.5 2.0 3.0 0.5 0.5 0.0 4.0]; % JIST_MODIF v2 tmp3 iContrast



 x0superf_VR=[2.0 3.0 0.5 0.5 0.0 1.5 2.0 3.0 0.5 0.5 0.5 1.0]; % Baixes_freq_zero tmp iContrast
%3.0000    2.6739    0.5000    0.7500    1.6052    1.5000    2.0000    2.9672    0.5000    0.4999    0.5000    0.5000


%x0superf_VR=[2.406462 0.788439 0.838273 0.993372 0.770077 0.024683 3.971177 0.941022 1.440777 0.306167 0.590519 4.999668]; % JIST modif2



%x0superf_VR=[1.000000 2.000000 1.250000 2.000000 2.000000 0.588081 3.388829 1.234838 0.956859 0.543858 0.987308 5.537735]; % Ajust ls
%x0superf_VR=[4.836827 0.972697 1.047379 0.767917 1.099785 0.476050 3.429963 1.386560 1.986888 0.797322 0.981884 6.000000]; % Ajust Y

%x0superf_VR=[4.836827 0.972697 1.047379 0.767917 1.099785 0.588081 3.388829 1.234838 0.956859 0.543858 0.987308 5.537735]; % Combinacio Ajust ls seguit de Ajust Y
%x0superf_VR=[4.981624 1.021035 1.048155 0.212226 0.530974 0.724440 3.611746 1.360638 0.796124 0.348766 1.059210 5.991295]; % tmp Ajust lsY
%x0superf_VR=[3.918152 0.582419 1.388962 0.423598 1.196267 0.689817 3.124853 1.316197 1.069142 0.406714 1.099753 5.999734]; % tmp Ajust lsY, without Y polarity problems

x0superf=[2. 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%x0superf=[1.754498 0.007198 0.008320 1.178705 2.975350 0.543979 0.004188 0.005074 0.768577 0.418773 1.704500 0.036656 2.433348 2.387362 2.835405 0.010195 2.163226 2.710239 2.962026 2.969320 0.021649 0.033051 0.722160 2.758065 1.036000 2.890738]; % tmp iContrast
%x0superf=[2.392702 0.007144 0.008269 1.206990 2.916244 1.234415 0.004065 0.004782 0.783948 0.922788 1.736172 0.033538 1.604191 2.307904 2.837644 0.020014 2.035708 2.489536 2.894351 2.977031 0.020728 0.034808 0.718131 2.729241 1.072358 2.875854; % tmp iContrast


% Direct sampling divisive norm
%x0superf_sampling=[1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   2.0];
%x0superf_sampling=[1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   50.0];
%x0superf_sampling=[1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   1.0 1.0 1.0 1.0 1.0   0.1]; % dwd_contrast

%x0superf_sampling=[0.007227 0.045442 0.033846 0.016883 0.214474 0.194801 0.156844 0.011235 0.007909 0.059847 0.792938 0.190835 0.176423 0.028047 0.001535 0.000100]; % ls iStdDevInt

%x0superf_sampling=[0.002396 0.022112 0.002507 0.002008 0.062221 0.037507 0.038947 0.016796 0.001582 0.002369 0.521570 0.042267 0.014478 0.005971 0.006352 0.027278]; % Y iStdDevInt


%x0superf_sampling=[0.113499 0.067475 0.146236 0.045430 0.604288 0.503617 0.121666 0.045899 0.004870 0.034572 0.315328 0.703687 0.256235 0.212879 0.099983 0.734422 0.860691 0.605295 0.001073 1.437692]; % ls iStdDevInt

x0superf_sampling=[0.113499 0.067475 0.146236 0.045430 0.604288 0.503617 0.121666 0.045899 0.004870 0.034572 0.315328 0.703687 0.256235 0.212879 0.099983 0.734422 0.860691 0.605295 0.001073 4]; % ls iStdDevInt



x_superf_sampling_I=[0.739724 0.403342 0.105272 0.017579 0.007216 0.928640 1.384548 0.440300 0.082305 0.018026 0.055556 1.259935 9.999911 0.358114 0.092541 0.052569 0.284004 0.005010		2.0 0.089677 4.010000 ]; % Y DivNorm contrast

x_superf_sampling_Chrom=[3.644066 0.507672 0.384157 0.159482 9.204653 9.640822 9.899402 0.018171 0.008093 0.077563 9.540490 9.184812 9.151611 0.060698 0.030773 0.168843 7.099734 6.378636 	2.0 0.229124 4.000000]; % ls DivNorm



% Matrius de rotacio

x0=[1. 0. 0 1.]; % tmp
%x0=[0.263333 -1.935036 0.027425 0.238487]; % tmp
%x0=[0.874880 -0.113899 0.000961 1.440977 -0.854488 -0.224730]; % tmp
%x0=[1.252849 -3.118178 0.006644 3.027866 0.66 0.98]; %tmp
x0=[1 0 0 1 0.66 0.98]; %tmp
x0=[1.000052 -0.108122 0.000709 1.000000 0.660029 0.980001];

x0=[0 0.66 0.98];
x0=[-3.091202 0.659888 0.979932];
x0=[3.000935 0.040040 0.765540 10.467801];
x0colorspace=[1 0 0 0 1 0 0 0 1 0.66 0.98 27.5];
%x0colorspace=[5.887347 -0.672184 -1.873376 1.089017 12.376435 8.300168 1.030663 -1.135649 4.449531 -27.117507 -44.803735 3.241444];

%x0colorspace=[-1.897568 -0.000212 -1.101664 -1.471884 1.786754 1.220890 -0.386803 -0.746790 0.723264];
%x0colorspace=[-1.961119 0.078253 -1.174212 -1.404138 1.751981 0.847779 -0.454580 -0.758304 0.679481]; % tmp !!!

%x0colorspace=[0.693260 -0.007040 -0.115543 0.042770 0.239750 -0.825477 -0.072581 0.031376 2.368603 0.660000 0.529671 27.576514 ]; % tmp !!!


%param.x0superf=x0superf;

x0colordef=[1 0 1 1 0 0 0 1 1 1 0 1 1 0];


% trio els parametres a estimar
%x0=[x0superf x0colorspace];
x0=x0superf_VR;
x0=x_superf_sampling_I;
param.x_complementari=x_superf_sampling_Chrom;

%x0=x0colorspace;
%x0=x0colordef;

param.x0superf=x0;
param.x0colorspace=x0colorspace;
param.x0colordef=x0colordef;
param.ydata=ydata;
param.std_obsrv=std_obsrv;

%param.error='stdev';

%if param.error =='stdev'
%	param.ydata=ydata*0.;
%else
	param.ydata=ydata;
%end
	
CanviMin

%options=optimset(options,'MaxFunEvals',size(x0,2)*25,'DiffMaxChange',.5,'DiffMinChange',.01,'UseParallel','always')
options=optimset(options,'MaxFunEvals',size(x0,2)*25,'DiffMaxChange',.5,'DiffMinChange',CanviMin)
%options=optimset(options,'MaxIter',1,'DiffMaxChange',.5,'DiffMinChange',.1)

system('touch inici_time.flag');
%x=lsqcurvefit(@(x,xdata) CIWaM(x,xdata,param),x0,xdata,ydataCIWAM,LB,UB,options)
x=lsqcurvefit(@(x,xdata) virtual_observer_func_parallel(x,param),x0,xdata,ydata,LB,UB,options)
%virtual_observer_func_parallel(x0,param)

system('touch fi_time.flag');
%CIWaM(x0,xdata,param);
