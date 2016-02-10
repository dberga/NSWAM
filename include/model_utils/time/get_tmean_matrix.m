
function [meanized_image] = get_tmean_matrix(matrix_in,tinit,tfinal,sinit,sfinal,oinit,ofinal) 

        meanized_image = cell([length(sinit:sfinal),length(oinit:ofinal),1]);
        
       for s=sinit:sfinal
            for o=oinit:ofinal
                meanized_image{s}{o} = get_temporalMean(matrix_in,tinit,tfinal,s,o);
            end
       end
end

