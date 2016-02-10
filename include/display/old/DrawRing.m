function [Img]=DrawRing(Img, center_x, center_y, inner_radius, extern_radius, greyvalue)


alc=size(Img,1);
ampl=size(Img,2);

%maxi=min(y+height-1,alc)
%maxj=min(x+width-1,ampl)


[x,y]=meshgrid(1:ampl,1:alc);
rad1=7;c1=(x-center_x).^2+(y-center_y).^2-(extern_radius)^2<0;
rad2=5;c2=(x-center_x).^2+(y-center_y).^2-(inner_radius)^2<0;
anell=xor(c1,c2);

Img(anell==1)=greyvalue;
