function [] = mostra_resul_Param_var(Nom)

close all;

if strcmp(Nom(1:4),'mach')
    img=imread('Mach_OP.ppm');
    
elseif strcmp(Nom(1:3),'che')
    img=imread('Chevreul_pattern.ppm');
    
elseif strcmp(Nom(1:3),'whi')
    img=imread('White_effect_pattern_W2_256.ppm');
	 
end

NomFin=sprintf('%s.mat',Nom)
load (NomFin);

figure
subplot(2,1,1),imagesc(uint8(img_out),[0 255]);
subplot(2,1,2),plot(img(round((size(img,2)/2)),:,1),'--b');hold on;
subplot(2,1,2),plot(img_out(round((size(img_out,2)/2)),:,1),'r')



end