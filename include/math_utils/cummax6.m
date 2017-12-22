function [ matrix_2dim ] = cummax6( matrix_6dim )

    [M,N,S,O,P,C] = size(matrix_6dim);
    matrix_2dim = zeros(M,N);
    
    
    for i=1:M
        for j=1:N
            maximum = 0;
            for s=1:S
                for o=1:O
                    for p=1:P
                        for c=1:C
                            if matrix_6dim(i,j,s,o,p,c) >= maximum
                                maximum = matrix_6dim(i,j,s,o,p,c);
                            end
                        end
                    end
                end
            end
            matrix_2dim(i,j) = maximum;
        end
    end
    
end

