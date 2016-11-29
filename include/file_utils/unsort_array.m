function [ vector_out ] = unsort_array( vector_in )
    vector_out = vector_in(randperm(length(vector_in)));

end

