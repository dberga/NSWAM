clear variables;


% Parametres

niter=10;
prec=0.1;
de=3*3;
di=6*6;
multires='a_trous';
multires='wav';
%multires='wav_contrast';
%multires='curv';
%multires='gabor';
n_scales=0;
normal_input=4;
normal_output=2.0;
ON_OFF=2; % 0: separate, 1: abs, 2:square
nu_0=2;
parallel=0;


% Imatge a llegir

%img=imread('White_effect_pattern_W2_256.ppm'); factor_fila=2;
%img=imread('White_effect_pattern_W2.ppm'); factor_fila=2;
%img=imread('SBC_effect_pattern_SBC1_256.ppm'); factor_fila=2;
%img=imread('SBC_effect_pattern_SBC3_256.ppm'); factor_fila=2;
img=imread('Todorovic_effect_pattern_T_256.ppm'); factor_fila=2;
%img=imread('Assimilacio_verd_blau_petit.ppm'); factor_fila=4;
%img=imread('Benary_cross.ppm');
%img=imread('Contrast_Yellow_Green_256.ppm'); factor_fila=2;
%img=imread('hermann_ok.ppm'); img=img./2;
%img=imread('hermann.ppm'); img=img./2;
%img=imread('hermann_curved.ppm'); img=img./2;

%img=imread('PC091403_petit.ppm');
%img=imread('ball1_reg_halogen_petit.ppm');
%img=imread('ball1_reg_mb-5000+3202_petit.ppm');
%img=imread('ball2_reg_halogen_petit.ppm');
%img=imread('ball2_reg_mb-5000+3202_petit.ppm');
%img=imread('checkershadow_illusion4med_petit.ppm');
%img=imread('beau-lotto-color-cube-1_petit.ppm');
%img=imread('Color-Constancy_Lotto_Illusion_petit.ppm');

%img=imread('MachBands_ok.ppm');
%img=imread('Chevreul_pattern.ppm');
%img=imread('demo1.ppm');

% Downsampling

tmp=img;
img_in=tmp(1:2:size(tmp,1),1:2:size(tmp,2),:);
%img_in=img;


% Metode

img_out=NeuroCIWaM_Zaoping_Li(img_in, niter, prec,de,di,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,parallel);

% Resultats

if(parallel==0)
	figure,imshow(uint8(img_in),[]);
	figure,imshow(uint8(img_out),[]);
%	figure,imshow(double(img)./max(max(max(double(img_in)))),[]);
%	figure,imshow(img_out./max(max(max(img_out))),[]);
	
%	figure,plot(img_out(size(img_out,1)/2,:,1));
%	figure,plot(img_out(size(img_out,1)/2,:,2));
%	figure,plot(img_out(size(img_out,1)/2,:,3));

    figure,plot(img_in(round((size(img_in,1)/factor_fila)),:,1),'--r');hold on
    plot(img_out(round((size(img_out,1)/factor_fila)),:,1),'r');
    figure,plot(img_in(round((size(img_in,1)/factor_fila)),:,2),'--g');hold on
    plot(img_out(round((size(img_out,1)/factor_fila)),:,2),'g');
    figure,plot(img_in(round((size(img_in,1)/factor_fila)),:,3),'--b');hold on
    plot(img_out(round((size(img_out,1)/factor_fila)),:,3),'b');
end

imwrite(uint8(img_out),'out.ppm','PPM');


% Diferencia amb imatge original

dif=double(img_in)-img_out;
max(max(norm(dif(:,:,1))))
max(max(norm(dif(:,:,2))))
max(max(norm(dif(:,:,3))))
