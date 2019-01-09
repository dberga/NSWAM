function [ tp,fp ] = calc_roc( smap,fixes )

smap=uint8(floor(mat2gray(smap)*255));
thres=1:256;
sfixes=zeros(size(smap));
pred_fixes=smap>0;

for j=1:size(fixes,1)
    valSAL_XY=smap(fixes(j,2)+1,fixes(j,1)+1)+1;  
    sfixes(valSAL_XY)=sfixes(valSAL_XY)+1;
end

for j=1:size(pred_fixes,1)
    valSAL_XY=smap(pred_fixes(j,2)+1,pred_fixes(j,1)+1)+1;
    sfixes_out(valSAL_XY)=pred_fixes(valSAL_XY)+1;
end
sfixes_out=sfixes_out-sfixes;

for i=1:length(thres)
    tp(i)=sum(sfixes(thres(i):end))/sum(sfixes(:));
    fp(i)=sum(sfixes_out(thres(i):end))/sum(sfixes_out(:));
end
                        

end

