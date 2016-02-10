function [ rvalue ] = drandperm(type, min, max, r_length, notequal )

    
    switch type
        case 'int'
            rvalue = round(rvalue);
        otherwise
    end

    rvalue = randperm(max,r_length);    
        
    if ismember(rvalue,notequal) == 1
        rvalue = drandperm(type, min, max,r_length, notequal );
    end

end

