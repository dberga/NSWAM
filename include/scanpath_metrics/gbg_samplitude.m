function [  mean_amplitude, std_amplitude, amplitudes ] = gbg_samplitude( scanpath , gaze, ff_flag)
    if nargin<3, firstfixation_flag_default; end
    
    if iscell(scanpath)
        for p=1:length(scanpath)
            [all_mean_amplitude{p},all_std_amplitude{p},all_amplitudes{p}]=samplitude(scanpath{p}(gaze,:), ff_flag);
            
        end
        for p=1:length(scanpath)
           if ~exist('amplitudes')
               amplitudes=cell(1,length(all_amplitudes{p}));
           end
%            for g=1:length(all_amplitudes{p})
                amplitudes{gaze}=[amplitudes{gaze}; all_amplitudes{p}(gaze)];
%             end 
        end
        
        mean_amplitude=nanmean(cell2mat(all_mean_amplitude));
        std_amplitude=nanmean(cell2mat(all_std_amplitude));
        amplitudes=nanmean(cell2mat(amplitudes));
    else
        [mean_amplitude,std_amplitude,amplitudes]=samplitude(scanpath(gaze,:), ff_flag);
    end

end

