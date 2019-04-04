function [ mean_amplitude, std_amplitude, amplitudes ] = pp_samplitude( scanpath, ff_flag )
    if nargin<2, firstfixation_flag_default; end
    
    if iscell(scanpath)
        for p=1:length(scanpath)
            [all_mean_amplitude{p},all_std_amplitude{p},all_amplitudes{p}]=samplitude(scanpath{p},ff_flag);
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
        for g=1:length(amplitudes)
            amplitudes_alt(g)=nanmean(amplitudes{g});
        end
        mean_amplitude=nanmean(cell2mat(all_mean_amplitude));
        std_amplitude=nanmean(cell2mat(all_std_amplitude));
        amplitudes=amplitudes_alt;
    else
        [mean_amplitude,std_amplitude,amplitudes]=samplitude(scanpath,ff_flag);
        
    end
    
    
    
end

