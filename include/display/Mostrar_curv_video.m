function []=Mostrar_curv_video(curv,t_membr,scale,orient,frac_y,frac_x,n_cicles,bPlot,bLine,LimInf,LimSup,fps)


figure,imagesc(curv{t_membr}(:,:,scale,orient));colormap('gray');

n_ff=size(curv,1)

nplans=size(curv{1},3);


alc=size(curv{1}(:,:,scale,orient),1);
ampl=size(curv{1}(:,:,scale,orient),2);



if bPlot==1
	figure;
	for s=1:nplans
		funcio=zeros(n_ff,1);
		for ff=1:n_ff
			funcio(ff)=curv{ff}(int32(alc*frac_y),int32(ampl*frac_x),s,orient);
		end
		subplot(nplans,1,s),plot(funcio);
	end

	% FFT
		func_fft=abs(fft(funcio));
	figure,plot(func_fft); title('FFT');% axis([0 100 0 50]);

end

	if bLine~=0
		figure;
		
		funcio=zeros(n_ff,size(curv{1},2));
		for ff=1:n_ff
			funcio(ff,:)=curv{ff}(int32(alc*frac_y),:,scale,orient);
			plot(funcio(ff,:));
			video(ff)=getframe;
		end
		movie(video,n_cicles);
	end



% Pelicula

% 	for ff=1:n_ff
% 		frame(ff)=im2frame(uint8(curv{ff}(:,:,scale,orient)*255),'gray');
% 	end

if n_cicles~=0
	figure;
	for ff=1:n_ff
		if LimInf==0 & LimSup==0
			imagesc(curv{ff}(:,:,scale,orient));colormap('gray')
		else
			imagesc(curv{ff}(:,:,scale,orient),[LimInf LimSup]);colormap('gray')
		end
		video(ff)=getframe;
	end
	movie(video,n_cicles,fps);
end

	figure;
    curv_mig=zeros(size(curv{1}));
    	for ff=1:n_ff
            curv_mig=curv_mig+curv{ff};
        end
        curv_mig=curv_mig/n_ff;
    imagesc(curv_mig(:,:,scale,orient));colormap('gray');title('curv_mig');



figure,imagesc(curv{t_membr}(:,scale,orient));colormap('gray');
figure;

n_ff=size(curv,1);

nplans=size(curv{1},3);

for s=1:nplans
	ampl=size(curv{1}(:,:,s,orient),1);
	alc=size(curv{1}(:,:,s,orient),2);
	funcio=zeros(n_ff,1);
	for ff=1:n_ff
		funcio(ff)=curv{ff}(int32(alc*frac_y),int32(ampl*frac_x),s,orient);
	end
	subplot(nplans,1,s),plot(funcio);
end


end