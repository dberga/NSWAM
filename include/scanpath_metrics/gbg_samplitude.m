function [  mean_amplitude, std_amplitude, amplitudes ] = gbg_samplitude( scanpath , gaze )
    
    if iscell(scanpath)
        for p=1:length(scanpath)
            [all_mean_amplitude{p},all_std_amplitude{p},all_amplitudes{p}]=samplitude(scanpath{p}(gaze,:));
            
        end
        for p=1:length(scanpath)
           if ~exist('amplitudes')
               amplitudes=cell(1,length(all_amplitudes{p}));
           end
%            for g=1:length(all_amplitudes{p})
                amplitudes{gaze}=[amplitudes{gaze}; all_amplitudes{p}(gaze)];
%             end 
        end
        
        mean_amplitude=mean(cell2mat(all_mean_amplitude));
        std_amplitude=mean(cell2mat(all_std_amplitude));
        amplitudes=mean(cell2mat(amplitudes));
    else
        [mean_amplitude,std_amplitude,amplitudes]=samplitude(scanpath(gaze,:));
    end

end

