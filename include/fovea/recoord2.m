function [ output_matrix ] = recoord2( input_matrix,coords_input_rows, coords_input_cols)

    [M,N,C] = size(coords_input_rows); %i,j correspondence coords, same for cols
    output_matrix = zeros(M,N,C);
    
%     %kk=repmat(coords_input_rows(:,:) > 0 & coords_input_rows(:,:) < M & coords_input_cols(:,:) > 0 & coords_input_cols(:,:) < N,[1 1 C]);
%      kk=coords_input_rows(:,:) > 0 & coords_input_rows(:,:) < M & coords_input_cols(:,:) > 0 & coords_input_cols(:,:) < N;
%   
%    % kk=repmat(coords_input_rows(:,:) > 0 & coords_input_rows(:,:) < M & coords_input_cols(:,:) > 0 & coords_input_cols(:,:) < N,[1 1 C]);
%     
%     valid_coords_rows = coords_input_rows(kk>0);
%     valid_coords_cols = coords_input_cols(kk>0);
%     
%     output_matrix(find(kk>0)) = input_matrix(find(kk>0));
%     valid_coords_input_rows = kk.*coords_input_rows;
%     valid_coords_input_cols = kk.*coords_input_cols;
    
%     output_matrix(:,:,1) = input_matrix(valid_coords_input_rows>0,valid_coords_input_cols>0,1);

% coords = repmat(coords_input_rows,coords_input_cols,[1 1 3]);
% valid = coords()
% 
% output_matrix(valid) = input_matrix(coords(valid)); 
    
    %output_matrix = input_matrix(coords_input_rows > 0 & coords_input_rows < M & coords_input_cols > 0 & coords_input_cols < N);

%     for c=1:C
%         index = 1:M*N*C;
%         
% 
%     output_matrix(:,:,c) = input_matrix(repmat(coord_input_rows(coords_input_rows(:,:) > 0 & coords_input_rows(:,:) < M), coords_input_cols(coords_input_cols(:,:) > 0 & coords_input_cols(:,:) < N),[1 1 C]));
%     end
    
%     condit = coords_input_rows > 0 & coords_input_rows < M & coords_input_cols > 0 & coords_input_cols < N;
%     condit = double(condit); 
%     
%     coords_input_rows_new = condit.*coords_input_rows;
%     coords_input_cols_new = condit.*coords_input_cols;
%     
%     coords_input_rows_new = round(coords_input_rows_new);
%     coords_input_cols_new = round(coords_input_cols_new);
%     
%     for c=1:C
%     output_matrix(:,:,c) = input_matrix(coords_input_rows_new,coords_input_cols_new,c);
%     
%     end



    
    for i=1:M
        for j=1:N
           %if coords_input_rows(i,j) >= 0 && coords_input_rows(i,j) <= M && coords_input_cols(i,j) >= 0 && coords_input_cols(i,j) <= N
               output_matrix(i,j,:) = input_matrix(coords_input_rows(i,j),coords_input_cols(i,j),:);
           %else
           %    disp([coords_input_rows(i,j),coords_input_cols(i,j)]);
           %    output_matrix(i,j,:)  = 256;
           %end
        end
    end
end
