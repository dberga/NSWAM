function [ rvalue ] = drand(type, min, max, notequal )

    rvalue = min + (max-min).*rand(1);
    
    switch type
        case 'int'
            rvalue = round(rvalue);
        otherwise
    end
    
        
    if ismember(rvalue,notequal) == 1
        rvalue = drand(type, min, max, notequal );
    end

end

