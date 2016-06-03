
function [meanized_image] = get_timean_matrix(matrix_in,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal) 

        meanized_image = cell([length(sinit:sfinal),length(oinit:ofinal)]);
        
       for s=sinit:sfinal
            for o=oinit:ofinal
                for c=1:size(matrix_in{tinit}{iinit}{s}{o},3)
                    meanized_image{s}{o}(:,:,c) = get_temporaliterMean(matrix_in,tinit,tfinal,iinit,ifinal,s,o,c);
                end
            end
       end
end

