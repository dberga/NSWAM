

%%%%%%%%%%%%%%%%%%%%%%% function that meanizes temporal matrix

function [matrix] = timatrix_to_matrix(timatrix,struct)

    
    
    tinit=struct.zli_params.n_membr-struct.zli_params.n_frames_promig+1; %index start at 1
    tfinal = struct.zli_params.n_membr;
    iinit=1;
    ifinal=struct.zli_params.n_iter; %all
    sinit = struct.wave_params.ini_scale;
    sfinal = struct.wave_params.fin_scale;
    oinit = 1;
    ofinal = struct.wave_params.n_orient;
    m_type = struct.fusion_params.tmem_res;
    
    if strcmp(m_type,'mean') == 1
        matrix = get_timean_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    elseif strcmp(m_type,'max') == 1
        matrix = get_timax_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    elseif strcmp(m_type,'wmax') == 1
        matrix = get_tiwmax_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    else
        matrix = get_timean_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    end
    
end




