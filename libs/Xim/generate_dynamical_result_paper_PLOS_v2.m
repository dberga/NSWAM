
% data (3 stands for stimulus 3 and so on)
%load dynamic3_curv.mat
%load dynamic3_curv_final.mat
%load dynamic3_400tmembr_2Hz__curv.mat
%load dynamic3_400tmembr_2Hz__curv_final.mat
%load dynamic3_100tmembr_2Hz__curv.mat
%load dynamic3_100tmembr_2Hz__curv_final.mat
load dynamic3_400_100tmembr_2Hz_flanks_20_curv.mat
load dynamic3_400_100tmembr_2Hz_flanks_20_curv_final.mat
% scale we consider
scale=1;
% note (about scale): scale 2 and higher are not interesting since the
% input is already in counterphase to the oscillation of the flanks 

% frequency
% warning! this is not the frequency of the input but the frequency used
% to quantify the modulation response (cf. Figure 3. Rossi and Paradiso)
% but: it determines the perdio of the sliding squarewave using the formula
% N=100/(2*Hz) and accordingly is equal to the aforementioned frequency
% morality: if the oscillation frequency is f, Hz has to be equal to f
Hz=2;

% plot both the input and the ouput
veure_contrafase_v2(curv,scale,Hz)
filtrada=veure_contrafase_v2(curv_final,scale,Hz);

createfigure_fig2_3_Rossi_Paradiso(filtrada);

