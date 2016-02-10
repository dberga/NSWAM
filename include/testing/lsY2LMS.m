function LMS = lsY2LMS(lsY)

[n,m,p] = size(lsY);
LMS = zeros(n,m,p);
    for i=1:n
        LM=lsY(i,3);
        L=lsY(i,1)*LM;
        M=LM-L;
        S=lsY(i,2)*LM;
        LMS(i,:)=[L M S];
    end
