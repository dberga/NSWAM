function []=Mostrar_gabor_video(curv,nplans,orient,frac_y,frac_x)

figure,imagesc(curv{1}{1}{orient});colormap('gray');
figure;

n_ff=size(curv,1);

for s=1:nplans
	ampl=size(curv{1}{s}{orient},1);
	alc=size(curv{1}{s}{orient},2);
	funcio=zeros(n_ff,1);
	for ff=1:n_ff
		funcio(ff)=curv{ff}{s}{orient}(alc*frac_y,ampl*frac_x);
	end
	subplot(nplans,1,s),plot(funcio);
end


end