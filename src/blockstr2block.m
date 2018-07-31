function [ block ] = blockstr2block( block_str,  blocks)
    for f=1:length(block_str)
        for l1=1:length(blocks)
            if strcmp(block_str{f},blocks{l1})
                block(f)=l1;
            end
        end
    end
    
    
end

