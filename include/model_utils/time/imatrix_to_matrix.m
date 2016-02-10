%%%%%%%%%%%%%%%%%%%%%%% function that meanizes temporal matrix

function [matrix] = imatrix_to_matrix(imatrix,struct,portion)
    %portion=1 is all, portion=2 is from 1 to half, portion=3 is from half+1 to end
    switch portion
        case 1
            tinit=1;
            tfinal = struct.zli.n_membr;
        case 2
            tinit=1;
            tfinal = floor(struct.zli.n_membr/2);
        case 3
            tinit=ceil(struct.zli.n_membr/2);
            tfinal = struct.zli.n_membr;
        otherwise
            tinit=1;
            tfinal = struct.zli.n_membr;
    end
    
    

    
    matrix = get_temporalMean2(imatrix,tinit,tfinal);
    
    
end




