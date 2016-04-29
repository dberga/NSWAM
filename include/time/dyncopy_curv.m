function [curv] = dyncopy_curv(curv,n_scales,n_membr)

    % replicate wavelet planes to n membrane

        
        for s=1:n_scales
            for o=1:size(curv{1}{s},2)
                for ff=2:n_membr
                    curv{ff}{s}{o}=curv{1}{s}{o};
                end
            end
        end


end

