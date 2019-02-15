function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff  ] = pp_samplitude_diff( scanpath1,scanpath2 )
    
    [~,~,amplitudes1]=pp_samplitude(scanpath1);
    [~,~,amplitudes2]=pp_samplitude(scanpath2);
    amplitudes_diff=abs(amplitudes1-amplitudes2);
    mean_amplitude_diff=mean(amplitudes_diff);
    std_amplitude_diff=std(amplitudes_diff);
    

end

