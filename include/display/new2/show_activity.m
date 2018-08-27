
function [ RFmean , RFmeanmean, RFmax, RFmaxmax, RFsum,RFsumsum , RFsingle] = show_activity( matrix, tinit, tfinal, iterinit, iterfinal, sinit, sfinal, oinit, ofinal )
            
            total_t = tfinal-tinit+1;
            total_iter = iterfinal-iterinit+1;
            total_s = sfinal-sinit+1;
            total_o = ofinal-oinit+1;
            
            count = 1;
            RFmean = zeros(total_s,total_o,total_t*total_iter);
            RFmeanmean = zeros(total_t*total_iter);
            RFmax = zeros(total_s,total_o,total_t*total_iter);
            RFmaxmax = zeros(total_t*total_iter);
            RFsum = zeros(total_s,total_o,total_t*total_iter);
            RFsumsum = zeros(total_t*total_iter);
            RFsingle = zeros(total_t*total_iter); 
            X = round(size(matrix{tinit}{iterinit}{sinit}{oinit}(:,:),2)/2); 
            Y = round(size(matrix{tinit}{iterinit}{sinit}{oinit}(:,:),1)/2);
            for t=tinit:tfinal
                for iter=iterinit:iterfinal
                    %set(gcf, 'Position', get(0,'Screensize'));
                    %title('RF');
                    %xlabel(['orient ' int2str(oinit) '...' int2str(ofinal) ]);
                    %ylabel(['scales ' int2str(sinit) '...' int2str(sfinal) ]);
                    

                    RFmean(:,:,count) = mean_RF( matrix, t, iter, sinit, sfinal, oinit, ofinal );
                    RFmeanmean(count) = nanmean(nanmean(RFmean(:,:,count)));
                    RFmax(:,:,count) = max_RF( matrix, t, iter, sinit, sfinal, oinit, ofinal );
                    RFmaxmax(count) = nanmax(nanmax(RFmax(:,:,count)));
                    RFsum(:,:,count) = sum_RF( matrix, t, iter, sinit, sfinal, oinit, ofinal );
                    RFsumsum(count) = nansum(nansum(RFsum(:,:,count)));
                    RFsingle(count) = matrix{t}{iter}{sinit}{oinit}(Y,X);
                    count = count+1;
                end
            end
            
        
end

