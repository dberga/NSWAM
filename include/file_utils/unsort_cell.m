function [ vector_out ] = unsort_cell( vector_in )
    vector_out = vector_in;
    
    newperm = randperm(numel(vector_in),numel(vector_in));
    for i=1:numel(vector_in)
        j = newperm(i);
        vector_out{i} = vector_in{j};
    end

end

