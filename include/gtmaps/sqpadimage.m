function [ Ipad ] = sqpadimage( I )

    [M,N] = size(I);
    X = max(size(I));
    Mdf = X-M;
    Ndf = X-N;
    
    Ipad = zeros(X,X);
    Ipad(Mdf+1:X,Ndf+1:X) = I;
end

