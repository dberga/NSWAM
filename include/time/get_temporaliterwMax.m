
function [tempMax] = get_temporaliterwMax(matrix_in,tinit,tfinal,iinit,ifinal,s,o,c) 
    
    tempMax = zeros(size(matrix_in{tinit}{iinit}{s}{o}(:,:,c)));
    valmax=-Inf;
    
    for ff=tinit:tfinal
        for it=iinit:ifinal
            %if mean(mean(matrix_in{ff}{it}{s}{o}(:,:,c))) ~= max(max(matrix_in{ff}{it}{s}{o}(:,:,c)))
                for x=1:size(matrix_in{ff}{it}{s}{o},1)
                    for y=1:size(matrix_in{ff}{it}{s}{o},2)
                        if valmax <=  matrix_in{ff}{it}{s}{o}(x,y,c) 
                           tempMax = matrix_in{ff}{it}{s}{o}(:,:,c);
                           valmax=matrix_in{ff}{it}{s}{o}(x,y,c) ;
                        end
                    end
                end
            %end
        end
    end
    
end

    
