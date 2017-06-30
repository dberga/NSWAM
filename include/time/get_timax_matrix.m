
function [max_image] = get_timax_matrix(matrix_in,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal) 

        max_image = cell([length(sinit:sfinal),length(oinit:ofinal)]);
        

       for s=sinit:sfinal
            for o=oinit:ofinal
                for c=1:size(matrix_in{tinit}{iinit}{s}{o},3)
                max_image{s}{o}(:,:,c) = get_temporaliterMax(matrix_in,tinit,tfinal,iinit,ifinal,s,o,c);
                end
            end
       end
end



