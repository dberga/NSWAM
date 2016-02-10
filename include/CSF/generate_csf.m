function zctr_csf = generate_csf(zctr,s,nu_0, mode,eCSF_type)
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

if strcmp(eCSF_type,'Xavier')
    
    if strcmp(mode,'intensity')
        params.fOffsetMax=0.;
        params.fContrastMaxMax=1;
        params.fContrastMaxMin=0.;
        params.fSigmaMax1=1.25;
        params.fSigmaMax2=1.25;
        params.fContrastMinMax=1.;
        params.fContrastMinMin=1.;
        params.fSigmaMin1=2;
        params.fSigmaMin2=1.;
        params.fOffsetMin=2;
    else
        params.fOffsetMax=1;
        params.fContrastMaxMax=2;
        params.fContrastMaxMin=0.;
        params.fSigmaMax1= 2;
        params.fSigmaMax2=1.25;
        params.fContrastMinMax=1.;
        params.fContrastMinMin=1.;
        params.fSigmaMin1=2;
        params.fSigmaMin2=2;
        params.fOffsetMin=2;
    end
else
    
% Naila (values obtained from global optimization)

    if strcmp(mode,'intensity')
        params.fOffsetMax=0.;
        params.fContrastMaxMax=4.981624;
        params.fContrastMaxMin=0.;
        params.fSigmaMax1=1.021035;
        params.fSigmaMax2=1.048155;
        params.fContrastMinMax=1.;
        params.fContrastMinMin=1.;
        params.fSigmaMin1=0.212226;
        params.fSigmaMin2=2.;
        params.fOffsetMin=0.530974;
    else
        params.fOffsetMax=0.724440;
        params.fContrastMaxMax=3.611746;
        params.fContrastMaxMin=0.;
        params.fSigmaMax1= 1.360638;
        params.fSigmaMax2=0.796124;
        params.fContrastMinMax=1.;
        params.fContrastMinMin=1.;
        params.fSigmaMin1=0.348766;
        params.fSigmaMin2=0.348766;
        params.fOffsetMin=1.059210;
    end
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
