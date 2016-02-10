function [funcio_out]=Mostrar_curv_video_POOL(curv,scale,orient,frac_y,frac_x)

% figure,imagesc(curv{1}{1}{orient});colormap('gray');

figure;

Dx=3; % was 2
Dy=3; % was 2

n_ff=size(curv,1);

nplans=size(curv{1},3);



for s=1:nplans
	alc=size(curv{1},1);
	ampl=size(curv{1},2);
	funcio=zeros(n_ff,1);
	for ff=1:n_ff
		funcio(ff)=mean(mean(curv{ff}...
            (int32(alc*frac_y)-Dy:int32(alc*frac_y)+Dy,int32(ampl*frac_x)-Dx:int32(ampl*frac_x)+Dx,s,orient)));
	end
	subplot(nplans,1,s),plot(funcio);
	if s==scale
		funcio_out=funcio;
	end
end



	% FFT
%	func_fft=abs(fft(funcio));
%	figure,plot(func_fft); title('FFT');% axis([0 100 0 50]);











% for s=1:nplans
% 	ampl=size(curv{1}{s}{orient},1);
% 	alc=size(curv{1}{s}{orient},2);
% 	funcio=zeros(n_ff,1);
% 	for ff=1:n_ff
% 		funcio(ff)=mean(mean(curv{ff}{s}{orient}...
%             (int32(alc*frac_y)-Dy:int32(alc*frac_y)+Dy,int32(ampl*frac_x)-Dx:int32(ampl*frac_x)+Dx)));
% 	end
% 	subplot(nplans,1,s),plot(funcio);
% end


end