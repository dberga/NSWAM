
function [matrix] = tmatrixc_to_matrixc(tmatrixc,struct, channel, portion)
    %portion=1 is all, portion=2 is from 1 to half, portion=3 is from half+1 to end
    if nargin < 3
        portion = 1;
    end
    
    tinit=1;
    tfinal = struct.zli.n_membr;
    sinit = struct.wave.ini_scale;
    sfinal = struct.wave.fin_scale;
    oinit = 1;
    ofinal = struct.wave.n_orient;
    
    m_type = struct.image.tmem_res;
    
    if strcmp(m_type,'mean') == 1
        matrix = get_tmean_matrixc(tmatrixc,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel);
    else if strcmp(m_type,'max') == 1
        matrix = get_tmax_matrixc(tmatrixc,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel);
    else
        matrix = get_tmean_matrixc(tmatrixc,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel);
    end
    
end



