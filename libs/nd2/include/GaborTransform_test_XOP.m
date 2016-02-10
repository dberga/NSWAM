clear variables;

tic
img=imread('cameraman.tif');

% img_tmp=imread('PC091403_petit.ppm');
% img=img_tmp(:,:,1)+img_tmp(:,:,2)+img_tmp(:,:,3);
% img=img/3;

% Rectangle
% img=zeros(256,256);
% img(100:150,100:150)=255;


%figure,imshow(uint8(img),[]);

% a=2;
% %a=size(img)/2;
% M=4;
% %L=max(size(img,1),size(img,2));
% %L=16;
% L1=size(img,1);
% L2=size(img,2);
% L=[L1 L2];
% 
% % g=gabwin('gauss',a,M,L);
%  g1=gabwin('gauss',a,M,L1);
%  g2=gabwin('gauss',a,M,L2);
% % gd=gabwin('dualgauss',a,M,L);
%  gd1=gabwin('dualgauss',a,M,L1);
%  gd2=gabwin('dualgauss',a,M,L2);
% % g=gabwin('tight',a,M,L)
% % %figure,surf(fftshift(reshape(g,16,16)))
% % gd=gabwin('tight',a,M,L);
% 
% [coef,Ls] = dgt2(img,g1,g2,[a,a],[M,M],L);
% %[coef,Ls] = dgt2(img,g,a,M,L);
% 
% figure
%  for i=1:M
%     for j=1:M
%          subplot(M,M,(i-1)*M+j),subimage(reshape(abs(coef(i,:,j,:))./255,size(abs(coef(i,:,j,:)),2),size(abs(coef(i,:,j,:)),4)))
%        %       kk{i,j}=reshape(abs(coef(i,:,j,:)),L,L);
% %       figure,imagesc(reshape(abs(coef(i,:,j,:)),L,L));colormap(gray);
% %       figure,imshow(reshape(abs(coef(i,:,j,:))./255,L,L));
%     end
%  end
% %c=c*4;
% %plotdgt(c,a)
% rec = idgt2(coef,gd1,gd2,[a a],Ls);
% %rec = idgt2(coef,gd,a,Ls);

n_scales=5;
[coef,Ls]=GaborTransform_XOP(img,n_scales);


% figure
%  for i=1:M
%     for j=1:M
%          subplot(M,M,(i-1)*M+j),subimage(reshape(abs(coef(i,:,j,:))./255,size(abs(coef(i,:,j,:)),2),size(abs(coef(i,:,j,:)),4)))
%     end
%  end



rec=IGaborTransform_XOP(coef,n_scales,Ls);

figure,imshow(uint8(img),[0 255]);
figure,imshow(uint8(rec),[0 255]);
dif=double(img)-rec;
%max(norm(dif))
%figure,imagesc(dif);colormap(gray);
toc