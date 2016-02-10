function filtrada=veure_contrafase_v2(curv_final,scale,Hz)

% from veure_contrafase.m   (21/9/12)
% only plot the response of the central neuron

funcio=Mostrar_curv_video_POOL(curv_final,scale,1,65/128,65/128);
funcio_rep=repmat(funcio,1,1);

filtrada=imfilter(funcio_rep,(ones(1,floor(100/(Hz*2)))/floor(100/(Hz*2)) )' , 'symmetric');
figure,plot(filtrada);


	% FFT
	
	%func_fft=abs(fft(funcio_rep));
	%figure,plot(func_fft); title('FFT'); %axis([0 100 0 512]);


end