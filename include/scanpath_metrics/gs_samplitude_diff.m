function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff ] = gs_samplitude_diff( scanpath1, scanpath2g, gaze , ff_flags)
    if nargin<4, firstfixation_flag_default; end
    
    if iscell(scanpath1)
        for p=1:length(scanpath1)
%             all_scanpath1g=repmat(scanpath1{p}(gaze,:),size(scanpath2g,1),1);
            try
                [all_mean_amplitude_diff{p}, all_std_amplitude_diff{p}, all_amplitudes_diff{p}]=samplitude_diff(scanpath1(gaze,:),scanpath2g(p,:),ff_flags);
            catch
                all_mean_amplitude_diff{p}=NaN;
                all_std_amplitude_diff{p}=NaN;
                all_amplitudes_diff{p}=NaN;
            end
        end
        mean_amplitude_diff=nanmean(cell2mat(all_mean_amplitude_diff));
        std_amplitude_diff=nanmean(cell2mat(all_std_amplitude_diff));
        amplitudes_diff=cell2mat(all_mean_amplitude_diff);
    else
        scanpath1g=repmat(scanpath1(gaze,:),size(scanpath2g,1),1);
        [mean_amplitude_diff, std_amplitude_diff, amplitudes_diff]=samplitude_diff(scanpath1g,scanpath2g,ff_flags);
    end
    
    
end


