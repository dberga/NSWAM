function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff  ] = pp_samplitude_diff( scanpath1,scanpath2, ff_flags )
    if nargin<3, firstfixation_flag_default; end
    
    [~,~,amplitudes1]=pp_samplitude(scanpath1,ff_flags(1));
    [~,~,amplitudes2]=pp_samplitude(scanpath2,ff_flags(2));
    
    
    if length(amplitudes1) ~= length(amplitudes2)
        if length(amplitudes1)>length(amplitudes2)
            amplitudes2(length(amplitudes2):length(amplitudes1))=NaN;
        elseif length(amplitudes1)<length(amplitudes2)
            amplitudes1(length(amplitudes1):length(amplitudes2))=NaN;
        end
    end
    
    amplitudes_diff=abs(amplitudes1-amplitudes2);
    mean_amplitude_diff=nanmean(amplitudes_diff);
    std_amplitude_diff=nanstd(amplitudes_diff);
    

end

