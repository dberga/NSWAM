
function [ h ] = show_activity_plots( activity )
            
            [total_s,total_o,total_dyn] = size(activity);
            plotsize = 128;
            mosaic = zeros(plotsize,plotsize,1,total_dyn);
            
            count = 1;
            for s=1:total_s
                for o=1:total_o
                    dynamic(1,:) = activity(s,o,:);
                    figure; fig = plot(1:total_dyn,dynamic); 
                    mosaic(:,:,1,count) = frame2im(getframe(fig));
                    count = count+1;
                end
            end
            
            h = montage(mosaic, 'Size',[total_s total_o]);
            
            
        
end

