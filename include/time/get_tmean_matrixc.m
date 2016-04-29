
function [meanized_image] = get_tmean_matrixc(matrix_in,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel) 

        meanized_image = cell([length(sinit:sfinal),length(oinit:ofinal),1]);
        
       for s=sinit:sfinal
            for o=oinit:ofinal
                meanized_image{s}{o} = get_temporalMeanc(matrix_in,tinit,tfinal,s,o,channel);
            end
       end
end

