
function [tempMax] = get_temporalMax(matrix_in,tinit,tfinal,iinit,ifinal,s,o,c) 
    
    tempMax = zeros(size(matrix_in{tinit}{s}{o}(:,:,c)));
    
    for ff=tinit:tfinal
        for it=iinit:ifinal
            for x=1:size(matrix_in{ff}{it}{s}{o},1)
                for y=1:size(matrix_in{ff}{it}{s}{o},2)

                    if tempMax(x,y) <  matrix_in{ff}{it}{s}{o}(x,y,c)
                       tempMax(x,y) = matrix_in{ff}{it}{s}{o}(x,y,c);
                    end
                end
            end
        end
    end
    
end

    
