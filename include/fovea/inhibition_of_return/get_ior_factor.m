
 function [ factor ] = get_ior_factor( time, max_time, iter, max_iter , slope_ctt)
 
    if ~exist('iter','var') iter = 1; end;
    if ~exist('max_iter','var') max_iter = iter; end;
    if ~exist('slope_ctt','var') slope_ctt = exp(0.5); end;
    
    t = (((time-1) ./ max_time)+((1./max_iter).*((iter-1) ./ (max_iter-1))));
    s = exp(slope_ctt);
    
    factor = s.^(1-t) - (s-1).^(1-t);
end
 

 