function [res] = convolucio_optima_FFT (data, filter)

%
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
%

% if(log2(numel(data))*2<numel(filter))
%    res=fftfilt(filter,data);
% else
%    res=convn(data,filter,'same');
% end


res=ifftn(data*filter);

end