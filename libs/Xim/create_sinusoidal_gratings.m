% create simusoidal gratings
% names: sinus_size_f.ppm, where f is the frequency

size=256;
vec_f=[7,9,11,13,17,19,23,27,39,43,53,59,65,77,83,91,103,107,113,123];
for i=1:length(vec_f)
    f=vec_f(i);
    a=(0:(2*pi*f)/256:255*(2*pi*f)/256);
    b=repmat(a,256,1);
    c=cos(b);
    d=uint8(127.*(c+1));
    name=strcat('sinus_',num2str(size),'_',num2str(f),'.ppm');
    imwrite(d,name,'ppm');
end
    