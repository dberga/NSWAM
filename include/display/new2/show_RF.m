function [ h ] = show_RF( matrix, t,iter,sinit,sfinal,oinit,ofinal )
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            
            RF = matrix{t}{iter};
            mat = rf2mat(RF);
            mosaic = zeros(size(mat,1),size(mat,2),1,size(mat,3)*size(mat,4));
            
            count = 1;
            for s=sinit:sfinal
                for o=oinit:ofinal
                    mosaic(:,:,1,count) = mat(:,:,s,o);
                    count = count+1;
                end
            end
            
            h = montage(mosaic, 'Size',[total_s total_o]);
            
            
end

