function []=Mostrar_img_video(img,frac_y,frac_x,channel,n_cicles,bPlot,bLine)

n_ff=size(img,4);

alc=size(img,1);
ampl=size(img,2);

if bPlot~=0
	funcio=zeros(n_ff);
	for ff=1:n_ff
		funcio(ff)=img(int32(alc*frac_y),int32(ampl*frac_x),channel,ff);
	end
	figure,plot(funcio);%axis([-100 300 -100 300]);
	
	% FFT
	
	func_fft=abs(fft(funcio));
	figure,plot(func_fft); title('FFT');% axis([0 100 0 512]);
	
end



% Pelicula

% 	for ff=1:n_ff
% 		frame(ff)=im2frame(uint8(curv{ff}(:,:,scale,orient)*255),'gray');
% 	end

if n_cicles~=0
	
	if bLine~=0
		figure;
		
		funcio=zeros(n_ff,size(img,2));
		for ff=1:n_ff
			funcio(ff,:)=img(int32(alc*frac_y),:,channel,ff);
			plot(funcio(ff,:));;ylim([0 300]);
			video(ff)=getframe;
		end
		movie(video,n_cicles);
	end

func_mig=mean(funcio,1);
figure,plot(func_mig);title('func_mig');
	
	figure;
	for ff=1:n_ff
		imagesc(img(:,:,channel,ff));colormap('gray')
		video(ff)=getframe;
	end
	movie(video,n_cicles,4);
	
	
end
	figure;
    img_out_mig=mean(img,4);
    imagesc(img_out_mig(:,:,channel));colormap('gray');title('img_mig');
end