function [ tp,fp ] = calc_sroc( smap,fixes,fixes_shuffle )

smap=uint8(floor(mat2gray(smap)*255));
thres=1:256;
sfixes=zeros(size(smap));
sfixes_shuffle=zeros(size(smap));

for j=1:size(fixes,1)
    valSAL_XY=smap(fixes(j,2)+1,fixes(j,1)+1)+1;  
    sfixes(valSAL_XY)=sfixes(valSAL_XY)+1;
end

for j=1:size(fixes_shuffle,1)
    valSAL_XY=smap(fixes_shuffle(j,2)+1,fixes_shuffle(j,1)+1)+1;
    sfixes_shuffle(valSAL_XY)=sfixes_shuffle(valSAL_XY)+1;
end


for i=1:length(thres)
    TP(i)=sum(sfixes(thres(i):end))/sum(sfixes(:));
    FP(i)=sum(sfixes_shuffle(thres(i):end))/sum(sfixes_shuffle(:));
end
                        

end

