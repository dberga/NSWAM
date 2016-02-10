% cercles assimilacio
im=imread('cercles_assimilacio.png');
figure,imshow(im)

x1=187;x2=222;
y1=318;y2=503;

colour=zeros(1,1,3);
colour(1,1,:)=[153 205 205];

band=zeros(size(im));
band(x1:x2,y1:y2,:)=uint8(repmat(colour,[x2-x1+1,y2-y1+1,1]));

imband=im;
imband(x1:x2,y1:y2,:)=band(x1:x2,y1:y2,:);

figure, imshow(imband)