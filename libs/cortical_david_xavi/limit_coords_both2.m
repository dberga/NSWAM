              

function [m_out,n_out,m_out2,n_out2] = limit_coords_both2(m_coords, n_coords,m_coords2,n_coords2, M_start, N_start, M_end,N_end)
        
    
    [idx1_row,idx1_col] = find(m_coords < M_start);
    [idx2_row,idx2_col] = find(m_coords > M_end);
    [idx3_row,idx3_col] = find(n_coords < N_start );
    [idx4_row,idx4_col] = find(n_coords > N_end);
    [out_idx_rows] = [idx1_col; idx1_col; idx3_row; idx4_row];
    [out_idx_cols] = [idx1_col; idx1_col; idx3_row; idx4_row];
    
    m_out = m_coords;
    n_out = n_coords;
    
    m_out(out_idx_rows,:) = 0;
    m_out(:,out_idx_cols) = 0;
    n_out(out_idx_rows,:) = 0;
    n_out(:,out_idx_cols) = 0;
    
    m_out( ~any(m_out,2), : ) = [];  %rows
    m_out( :, ~any(m_out,1) ) = [];  %columns
    n_out( ~any(n_out,2), : ) = [];  %rows
    n_out( :, ~any(n_out,1) ) = [];  %columns

    
    m_out2 = m_coords2;
    n_out2 = n_coords2;
    m_out2(out_idx_rows,:) = 0;
    m_out2(:,out_idx_cols) = 0;
    n_out2(out_idx_rows,:) = 0;
    n_out2(:,out_idx_cols) = 0;
    
    m_out2( ~any(m_out2,2), : ) = [];  %rows
    m_out2( :, ~any(m_out2,1) ) = [];  %columns
    n_out2( ~any(n_out2,2), : ) = [];  %rows
    n_out2( :, ~any(n_out2,1) ) = [];  %columns
    
    
    
end

