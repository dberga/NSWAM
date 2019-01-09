function [ mat_out] = so2mat( cell_in )
    
    S=length(cell_in);
    O=size(cell_in{1},3);
    N=size(cell_in{1},2);
    M=size(cell_in{1},1);
    mat_out=zeros(M,N,S,O);
    
    for s=1:S
       for o=1:O
           mat_out(:,:,s,o) = cell_in{s}(:,:,o);
       end
    end
    

end

