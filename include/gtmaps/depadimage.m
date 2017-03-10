function [ I ] = depadimage( Ipad, p, M, N )
    
    I = Ipad(p+1:p+M,p+1:p+N,:);

end

