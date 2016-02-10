function []=Mostrar_line_time(img,frac_y,frac_x,channel)

	
n_ff=size(img,4);

alc=size(img,1);
ampl=size(img,2);

funcio=zeros(n_ff,size(img,2));
line_time=zeros();

for ff=1:n_ff
    funcio(ff,:)=img(int32(alc*frac_y),:,channel,ff);
end

figure,imagesc(funcio); % colormap('gray');


figure,plot(funcio(:,int32(ampl*frac_x)));

end