
function [tempMax] = get_temporalMax(matrix_in,tinit,tfinal,s,o) 
    
    tempMax = zeros(size(matrix_in{tinit}{s}{o}(:,:)));
    
    for ff=tinit:tfinal
        for x=1:size(matrix_in{ff}{s}{o},1)
            for y=1:size(matrix_in{ff}{s}{o},2)
                if tempMax(x,y) <  matrix_in{ff}{s}{o}(x,y)
                   tempMax(x,y) = matrix_in{ff}{s}{o}(x,y);
                end
            end
        end
    end
    
end

    
