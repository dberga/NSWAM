function [ bmap ] = scanpath2bmap( scanpath , size)

M = size(1);
N = size(2);
bmap = zeros(M,N);
for k=1:size(scanpath,1)
    bmap(scanpath(k,2),scanpath(k,1)) = 1;
end


end

