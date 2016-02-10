

%%%%%%%%%%%%%%%%%%%%%%% function that meanizes temporal matrix

function [matrix] = tmatrix_to_matrix(tmatrix,struct, portion)
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
    
    m_type = struct.compute.tmem_res;
    
    if strcmp(m_type,'mean') == 1
        matrix = get_tmean_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
    else if strcmp(m_type,'max') == 1
        matrix = get_tmax_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
    else
        matrix = get_tmean_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
    end
    
end




