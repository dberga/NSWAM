function [ RF ] = cleanRF( RF )
    
    RF = RF(~cellfun('isempty',RF));
        n_membr = numel(RF);
        for t=1:n_membr
            RF{t} = RF{t}(~cellfun('isempty',RF{t}));
            n_iter = numel(RF{t});
            for iter = 1:n_iter
                RF{t}{iter} = RF{t}{iter}(~cellfun('isempty',RF{t}{iter}));
                n_scales = numel(RF{t}{iter});
                for s = 1:n_scales
                    RF{t}{iter}{s} = RF{t}{iter}{s}(~cellfun('isempty',RF{t}{iter}{s}));
                    n_orient = numel(RF{t}{iter}{s});
                
                end
            end
        end     
                

end

