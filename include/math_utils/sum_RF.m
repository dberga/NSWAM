function [ RFsum ] = sum_RF( matrix, t,iter,sinit,sfinal,oinit,ofinal )
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            
            RF = matrix{t}{iter};
            mat = rf2mat(RF);
            RFsum = zeros(size(mat,3),size(mat,4));
            
            count = 1;
            for s=sinit:sfinal
                for o=oinit:ofinal
                    RFsum(count) = nansum(nansum(mat(:,:,s,o)));
                    count = count+1;
                end
            end
            
            
            
end

