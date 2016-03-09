
function [max_image] = get_tmax_matrix(matrix_in,tinit,tfinal,sinit,sfinal,oinit,ofinal) 

        max_image = cell([length(sinit:sfinal),length(oinit:ofinal)]);
        

       for s=sinit:sfinal
            for o=oinit:ofinal
                for c=1:size(matrix_in{tinit}{s}{o},3)
                max_image{s}{o}(:,:,c) = get_temporalMax(matrix_in,tinit,tfinal,s,o,c);
                end
            end
       end
end



