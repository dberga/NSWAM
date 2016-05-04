function [ output_image, limits ] = pad_clean( input_image, token )

[M,N,C] = size(input_image);

    [row,col,~] = find(input_image(:,:,:)~=token ,M*N*C,'first');
    row = min(row);
    col = min(col);

% if row > 1 && col > 1
%    if row > col
%        col = 1;
%    end
%    
%    if col > row
%        row = 1;
%    end
%    
%    if col == row
%       row,col 
%    end
% end

output_image = input_image(row:M-row,col:N-col,:);

limits = [row M-row col N-col];





end



%mask = input_image~=token;
%mask = double(mask);
%output_image = double(input_image) .* mask;

%    output_image( ~any(output_image,2), :,: ) = [];  %rows
%    output_image( :, ~any(output_image,1),: ) = [];  %columns
