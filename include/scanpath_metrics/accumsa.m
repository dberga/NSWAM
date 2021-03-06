function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff ] = accumsa( scanpath1,scanpath2, ff_flags)
if nargin < 3, firstfixation_flag_default; end
if ff_flags(1) == 1
    scanpath1(1,:)=[];
end
if ff_flags(2) == 1
    scanpath2(1,:)=[];
end

min_gazes = min(size(scanpath1,1),size(scanpath2,1));
[~,~,amplitudes1]=samplitude(scanpath1,ff_flags);
[~,~,amplitudes2]=samplitude(scanpath2,ff_flags);

if length(amplitudes1) ~= length(amplitudes2)
    min_gazes_amp=min(length(amplitudes1),length(amplitudes2));
    amplitudes1(min_gazes_amp+1:end)=[];
    amplitudes2(min_gazes_amp+1:end)=[];
end

amplitudes_diff=NaN;
for i=1:size(amplitudes1,1)
    for j=1:size(amplitudes2,1)
        amplitudes_diff(i,j)=abs(amplitudes1(i,:)-amplitudes2(j,:));
    end
end
mean_amplitude_diff=nanmean(amplitudes_diff(:));
std_amplitude_diff=nanstd(amplitudes_diff(:));



end

