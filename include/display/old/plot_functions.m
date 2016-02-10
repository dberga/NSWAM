function [  ] = plot_functions(  )
end






function [] = saveplot_channel_figure_display(figin,format,output_folder,output_prefix,output_suffix,channel,frame)
    if(nargin < 7)
        frame = 'mean';
    end
    
    saveas(figin,[output_folder output_prefix '_' channel '_t(' frame ')' '_' output_suffix '.' format]);
    
end



function [figure_disp] = getfig_channel_display_example(image,frame,sinit,sfinal,oinit,ofinal,channel)
    

        figure_disp = figure;
        
        count = 0;
        for s=sinit:sfinal
            for o=oinit:ofinal
                count = count +1;
                
                
                subplot(length(sinit:sfinal),length(oinit:ofinal),count), subimage(image{frame}{s}{o}(:,:));
                title([channel '_t(' int2str(frame)  ')']);
                xlabel(['scale=' int2str(s)]);
                ylabel(['orientation' int2str(o)]);
                
                
            end
        end
        
        
        
end



    
function [figure_disp] = getfig_channel_display_example_per_time(image,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel)
    if(nargin < 8 )
        channel = 'channel';
    end
    
    
    for ff=tinit:tfinal
        figure_disp(ff) = getfig_channel_display_example(image,ff,sinit,sfinal,oinit,ofinal,channel);
    end

end





function [figure_disp] = getfig_channel_display_texample(image,sinit,sfinal,oinit,ofinal,channel)
    

        figure_disp = figure;
        
        count = 0;
        for s=sinit:sfinal
            for o=oinit:ofinal
                count = count +1;
                
                
                subplot(length(sinit:sfinal),length(oinit:ofinal),count), subimage(image{s}{o}(:,:));
                title([channel '_t(mean)']);
                xlabel(['scale=' int2str(s)]);
                ylabel(['orientation' int2str(o)]);
                
                
            end
        end
        
end


