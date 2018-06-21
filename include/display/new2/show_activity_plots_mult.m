
function [ h ] = show_activity_plots( activity )
            
            [total_s,total_o,total_dyn] = size(activity);
            plotsize = 128;
            mosaic = zeros(plotsize,plotsize,1,total_s*total_o);
            
            %figure(1); cla; hold on;
            count = 1;
            
            
            %myColors = distinguishable_colors(total_s*total_o);
            figure;
            hold on;
            for s=1:total_s
                for o=1:total_o
                    dynamic(1,:) = activity(s,o,:);
                    
                    %color = [(s/total_s) (o/total_o) 0.5];
                    %plot(1:total_dyn,dynamic,'color',color);
                    
                    %figure(count);
                    plot(1:total_dyn,dynamic);
                    %img = frame2im(getframe(figure(count)));
                    %mosaic(:,:,1,count) = imresize(img(:,:,1),[128 128]);
                    
                    
                    count = count+1;
                end
            end
            
            %h = montage(mosaic/255, 'Size',[total_s total_o]);
            h = gcf;
            hold off
            
        
end

