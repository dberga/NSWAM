function [MFactor] = coords_to_MFactor(X,Y,i,j,lambda)
    

    
    MFactor = exp((X - i) ./ lambda);
    MFactor = exp((Y - j) ./ lambda);
    
    

end

