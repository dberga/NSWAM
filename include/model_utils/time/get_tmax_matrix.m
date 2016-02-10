
function [max_image] = get_tmax_matrix(matrix_in,tinit,tfinal,sinit,sfinal,oinit,ofinal) 

        max_image = cell([length(sinit:sfinal),length(oinit:ofinal),1]);
        

       for s=sinit:sfinal
            for o=oinit:ofinal
                
                max_image{s}{o} = get_temporalMax(matrix_in,tinit,tfinal,s,o);
            end
       end
end



