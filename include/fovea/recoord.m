function [ output_matrix ] = recoord( input_matrix,output_matrix,coords_input_rows, coords_input_cols, coords_output_rows, coords_output_cols)

    
    for i=1:length(coords_input_rows)
           output_matrix(coords_output_rows(i),coords_output_cols(i),:) = input_matrix(coords_input_rows(i),coords_input_cols(i),:);

        
    end
end

