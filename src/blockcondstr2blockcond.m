function [ blockcond ] = blockcondstr2blockcond( blockcondstr,  blocks_cond)
    for f=1:length(blockcondstr)
        for l1=1:length(blocks_cond)
            if isnan(blockcondstr{f})
                blockcond(f)=1;
            end
            for l2=1:length(blocks_cond{l1})
                if strcmp(blockcondstr{f},blocks_cond{l1}{l2})
                    blockcond(f)=l2;
                end
            end
        end
    end
    
    
end

