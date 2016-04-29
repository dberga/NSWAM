function [ output_matrix ] = recoord2( input_matrix,output_matrix,coords_input_rows, coords_input_cols, coords_output_rows, coords_output_cols)

    [M,N] = size(coords_input_rows); %i,j correspondence coords, same for cols

    for i=1:M
        for j=1:N

            
           if coords_input_rows(i,j) > 0 && coords_input_rows(i,j) < M && coords_input_cols(i,j) > 0 && coords_input_cols(i,j) < M 
               output_matrix(coords_output_rows(i,j),coords_output_cols(i,j),:) = input_matrix(coords_input_rows(i,j),coords_input_cols(i,j),:);
           else
               output_matrix(coords_output_rows(i,j),coords_output_cols(i,j),:)  = -inf;
           end
        end
    end
end

