

%%%%%%%%%%%%%%%%%%%%%%% function that meanizes temporal matrix

function [matrix] = tmatrix_to_matrix(tmatrix,struct, portion)
    %portion=1 is all, portion=2 is from 1 to half, portion=3 is from half+1 to end
    if nargin < 3
        portion = 1;
    end
    
    tinit=struct.zli_params.n_membr-struct.zli_params.n_frames_promig+1; %index start at 1
    tfinal = struct.zli_params.n_membr;
    sinit = struct.wave_params.ini_scale;
    sfinal = struct.wave_params.fin_scale;
    oinit = 1;
    ofinal = struct.wave_params.n_orient;
    
    m_type = struct.fusion_params.tmem_res;
    
    if strcmp(m_type,'mean') == 1
        matrix = get_tmean_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
        matrix{sfinal+1} = tmatrix{tinit}{sfinal+1};
    else if strcmp(m_type,'max') == 1
        matrix = get_tmax_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
        matrix{sfinal+1} = tmatrix{tinit}{sfinal+1};
    else
        matrix = get_tmean_matrix(tmatrix,tinit,tfinal,sinit,sfinal,oinit,ofinal);
        matrix{sfinal+1} = tmatrix{tinit}{sfinal+1};
    end
    
end




