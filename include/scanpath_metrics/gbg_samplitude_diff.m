function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff ] = gbg_samplitude_diff( scanpath1, scanpath2, ff_flags )
    if nargin<3, firstfixation_flag_default; end
    
    [~,~,amplitudes1]=gbg_samplitude(scanpath1,gaze,ff_flags(1));
    [~,~,amplitudes2]=gbg_samplitude(scanpath2,gaze,ff_flags(2));
    if length(amplitudes1) ~= length(amplitudes2)
        minamps=min(length(amplitudes1),length(amplitudes2));
        amplitudes1(minamps+1:end)=[];
        amplitudes2(minamps+1:end)=[];
    end
    
    amplitudes_diff=abs(amplitudes1-amplitudes2);
    mean_amplitude_diff=nanmean(amplitudes_diff);
    std_amplitude_diff=nanstd(amplitudes_diff);


end

