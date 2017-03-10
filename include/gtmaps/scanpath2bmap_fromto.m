function [ bmap ] = scanpath2bmap_fromto( scanpath , fromscan, toscan ,size)

M = size(1);
N = size(2);
bmap = zeros(M,N);
for k=fromscan:toscan
    bmap(scanpath(k,2),scanpath(k,1)) = 1;
end


end

