function [  ] = show_TI_s_o_matrix( matrix, t,iter,sinit,sfinal,oinit,ofinal )
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            count=1;
            for s=sinit:sfinal
                for o=oinit:ofinal
                    subplot(total_s,total_o,count)
                    imagesc(matrix{t}{iter}{s}{o})
                    title(['scale=' num2str(s) ',orient=' num2str(o)]);
                    count = count+1;
                end
            end
end

