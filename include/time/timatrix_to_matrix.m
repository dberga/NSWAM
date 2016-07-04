

%%%%%%%%%%%%%%%%%%%%%%% function that meanizes temporal matrix

function [matrix] = timatrix_to_matrix(timatrix,struct)

    
    
    tinit=struct.zli.n_membr-struct.zli.n_frames_promig+1; %index start at 1
    tfinal = struct.zli.n_membr;
    iinit=1;
    ifinal=struct.zli.n_iter; %all
    sinit = struct.wave.ini_scale;
    sfinal = struct.wave.fin_scale;
    oinit = 1;
    ofinal = struct.wave.n_orient;
    m_type = struct.image.tmem_res;
    
    if strcmp(m_type,'mean') == 1
        matrix = get_timean_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    else if strcmp(m_type,'max') == 1
        matrix = get_timax_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    else
        matrix = get_timean_matrix(timatrix,tinit,tfinal,iinit,ifinal,sinit,sfinal,oinit,ofinal);
        %matrix{sfinal+1} = timatrix{tinit}{iinit}{sfinal+1};
    end
    
end




