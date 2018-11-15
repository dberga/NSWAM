function matrixk = MatChansMulK(m, k)
%MatChansMulK  scalar multiplication in each channel.
%
% inputs
%   m  the input matrix
%   k  the scalar vector contains same numebr of chanels as matrix.
%
% outputs
%   matrixk  the output matrix each chanel is multiplied by corresponding
%            'k' scalar, i.e. matrixk(:, :, 1) =  m(:, :, 1) .* k(1)
%

m = double(m);
[rows, cols, chns] = size(m);
k = reshape(k, 1, 3);

matrixk = zeros(rows, cols, chns);
for i = 1:chns
  matrixk(:, :, i) = k(1, i) .* m(:, :, i);
end

end
