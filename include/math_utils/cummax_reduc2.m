function [ matrix_out ] = cummax_reduc( matrix , cfrom, cto)
    [M,N,C] = size(matrix);
    matrix_out = zeros(M,N);
    
    maximum = 0;
    for i=1:M
        for j=1:N
            for c=cfrom:cto
                if matrix(i,j,c) >= maximum;
                    maximum = matrix(i,j,c);
                end
            end
            matrix_out(i,j) = maximum;
            maximum = 0;
        end
    end

end

