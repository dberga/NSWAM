function [ mean_amplitude, std_amplitude, amplitudes ] = pp_samplitude( scanpath )
    
    
    if iscell(scanpath)
        for p=1:length(scanpath)
            [all_mean_amplitude{p},all_std_amplitude{p},all_amplitudes{p}]=samplitude(scanpath{p});
            
        end
        for p=1:length(scanpath)
           if ~exist('amplitudes') 
               amplitudes=cell(1,length(all_amplitudes{p}));
           end
           for g=1:length(all_amplitudes{p})
               if length(all_amplitudes{p}) <= length(amplitudes)
                    amplitudes{g}=[amplitudes{g}, all_amplitudes{p}(g)];
               else
                   amplitudes{g}=[all_amplitudes{p}(g)];
               end
           end 
            
        end
        
        mean_amplitude=mean(cell2mat(all_mean_amplitude));
        std_amplitude=mean(cell2mat(all_std_amplitude));
        amplitudes=mean(cell2mat(amplitudes));
    else
        [mean_amplitude,std_amplitude,amplitudes]=samplitude(scanpath);
        
    end
    
    
    
end

