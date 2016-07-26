
function [ RFmean , RFmeanmean ] = show_activity( matrix, tinit, tfinal, iterinit, iterfinal, sinit, sfinal, oinit, ofinal )
            
            total_t = tfinal-tinit+1;
            total_iter = iterfinal-iterinit+1;
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            
            count = 1;
            RFmean = zeros(total_s,total_o,total_t*total_iter);
            RFmeanmean = zeros(total_t*total_iter);
            for t=tinit:tfinal
                for iter=iterinit:iterfinal
                    %set(gcf, 'Position', get(0,'Screensize'));
                    %title('RF');
                    %xlabel(['orient ' int2str(oinit) '...' int2str(ofinal) ]);
                    %ylabel(['scales ' int2str(sinit) '...' int2str(sfinal) ]);
                    

                    RFmean(:,:,count) = mean_RF( matrix, t, iter, sinit, sfinal, oinit, ofinal );
                    RFmeanmean(count) = mean(mean(RFmean(:,:,count)));
                    count = count+1;
                end
            end
            
        
end

