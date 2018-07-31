function [ Sw ] = WeberLaw( Ls,Lb )
% Ls mean saliency of target window
% Lb mean saliency of background (without taget window)

Sw=(Ls-Lb)/(Lb+0.001);

end

