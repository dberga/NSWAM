              

function [m_out,n_out,m_out2,n_out2] = limit_coords_both(m_coords, n_coords,m_coords2,n_coords2, M_start, N_start, M_end,N_end)
        
    
    idx1 = find(m_coords < M_start);
    idx2 = find(m_coords > M_end);
    idx3 = find(n_coords < N_start );
    idx4 = find(n_coords > N_end);
    out_idx = [idx1; idx2; idx3; idx4];
    
    m_out = m_coords;
    n_out = n_coords;
    m_out(out_idx) = [];
    n_out(out_idx) = [];
    
    m_out2 = m_coords2;
    n_out2 = n_coords2;
    m_out2(out_idx) = [];
    n_out2(out_idx) = [];

    
    
end

