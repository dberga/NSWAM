function [ maxval,idx1,idx2,idx3,idx4 ] = get_max_4dim( matrix_4dim )

maxval=-Inf;
for d1=1:size(matrix_4dim,1)
    for d2=1:size(matrix_4dim,2)
        for d3=1:size(matrix_4dim,3)
            for d4=1:size(matrix_4dim,4)
                if(matrix_4dim(d1,d2,d3,d4)>=maxval)
                   maxval= matrix_4dim(d1,d2,d3,d4);
                   idx1=d1;
                   idx2=d2;
                   idx3=d3;
                   idx4=d4;
                end
            end
        end
    end
end

end

