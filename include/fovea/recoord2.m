function [ output_matrix ] = recoord2( input_matrix,coords_input_rows, coords_input_cols)

    [M,N,C] = size(coords_input_rows); %i,j correspondence coords, same for cols
    output_matrix = zeros(M,N,C);
    


    
    for i=1:M
        for j=1:N
           if coords_input_rows(i,j) > 0 && coords_input_rows(i,j) <= M && coords_input_cols(i,j) > 0 && coords_input_cols(i,j) <= N
               output_matrix(i,j,:) = input_matrix(coords_input_rows(i,j),coords_input_cols(i,j),:);
           else
               disp([coords_input_rows(i,j),coords_input_cols(i,j)]);
               %output_matrix(i,j,:)  = 256;
           end
        end
    end
end
