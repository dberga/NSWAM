function zctr_csf = generate_csf_givenparams(zctr,s,nu_0, mode,params_intensity, params_chromatic)
% returns the value of the csf at a specific relative contrast and spatial frequency.
%
% outputs:
%   zctr_csf: matrix of csf_values
%
% inputs:
%   zctr: matrix of relative contrast values
%   s: matrix of spatial frequency values
%   nu_0: peak spatial frequency for CSF; suggested value of 4
%   mode: type of channel i.e. colour or intensity

% select for mode of channel:

% Xavier original (JoV) values

    if strcmp(mode,'intensity')
        params.fOffsetMax=params_intensity.fOffsetMax;
        params.fContrastMaxMax=params_intensity.fContrastMaxMax;
        params.fContrastMaxMin=params_intensity.fContrastMaxMin;
        params.fSigmaMax1=params_intensity.fSigmaMax1;
        params.fSigmaMax2=params_intensity.fSigmaMax2;
        params.fContrastMinMax=params_intensity.fContrastMinMax;
        params.fContrastMinMin=params_intensity.fContrastMinMin;
        params.fSigmaMin1=params_intensity.fSigmaMin1;
        params.fSigmaMin2=params_intensity.fSigmaMin2;
        params.fOffsetMin=params_intensity.fOffsetMin;
    else
        params.fOffsetMax=params_chromatic.fOffsetMax;
        params.fContrastMaxMax=params_chromatic.fContrastMaxMax;
        params.fContrastMaxMin=params_chromatic.fContrastMaxMin;
        params.fSigmaMax1= params_chromatic.fSigmaMax1;
        params.fSigmaMax2=params_chromatic.fSigmaMax2;
        params.fContrastMinMax=params_chromatic.fContrastMinMax;
        params.fContrastMinMin=params_chromatic.fContrastMinMin;
        params.fSigmaMin1=params_chromatic.fSigmaMin1;
        params.fSigmaMin2=params_chromatic.fSigmaMin2;
        params.fOffsetMin=params_chromatic.fOffsetMin;
    end

zctr_csf = apply_csf(s - nu_0,zctr,params);

end

function zctr_csf = apply_csf(s,zctr,csf_params)
% Equation of csf based on Otazu et al, 2008

fOffsetMax      = csf_params.fOffsetMax;
fContrastMaxMax = csf_params.fContrastMaxMax;
fContrastMaxMin = csf_params.fContrastMaxMin;
fSigmaMax1      = csf_params.fSigmaMax1;
fSigmaMax2      = csf_params.fSigmaMax2;

fContrastMinMax = csf_params.fContrastMinMax;
fContrastMinMin = csf_params.fContrastMinMin;
fSigmaMin1      = csf_params.fSigmaMin1;
fSigmaMin2      = csf_params.fSigmaMin2;
fOffsetMin      = csf_params.fOffsetMin;

fCsfMax = CSF(s-fOffsetMax, fContrastMaxMax, fContrastMaxMin, fSigmaMax1, fSigmaMax2);
fCsfMin = CSF(s-fOffsetMin, fContrastMinMax, fContrastMinMin, fSigmaMin1, fSigmaMin2);

zctr_csf = zctr.*fCsfMax + fCsfMin;

end

function fCsf = CSF(s, fContrastMax, fContrastMin, fSigma1, fSigma2)
% Equation of csf based on Otazu et al, 2008

fCsf(s > 0)  = (fContrastMax-fContrastMin).*exp(-(s(s > 0).*s(s > 0))./(2.*fSigma2*fSigma2))+fContrastMin;
fCsf(s <= 0) = fContrastMax.*exp(-(s(s <= 0).*s(s <= 0))./(2.*fSigma1*fSigma1));
fCsf         = reshape(fCsf,size(s));

end
