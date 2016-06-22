function [  ] = show_Factor_plot( matrix, tinit, tfinal, iterinit, iterfinal, sinit, sfinal, oinit, ofinal )

            total_t = tfinal-tinit+1;
            total_iter = iterfinal-iterinit+1;
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            
            count=1;
            for t=tinit:tfinal
                for iter=iterinit:iterfinal
                    for s=sinit:sfinal
                        for o=oinit:ofinal
                            subplot(total_s,total_o,count)
                            imagesc(matrix{t}{iter}{s}{o})
                            title(['scale=' num2str(s) ',orient=' num2str(o)]);
                            count = count+1;
                        end
                    end
                end
            end
            

end

