function [ m_out ] = clean_distort_frames( m_in , coords_changed_rows, coords_changed_cols)

    %m_out = m_in; 
    %m_out( ~any(m_out,2), :, : ) = [];  %rows
    %m_out( :, ~any(m_out,1) , :) = [];  %columns
    
    n_start = min(min(coords_changed_cols));
    n_end = max(max(coords_changed_cols));
    m_start = min(min(coords_changed_rows));
    m_end = max(max(coords_changed_rows));
    m_out = m_in(m_start:m_end,n_start:n_end,:);
    
end

