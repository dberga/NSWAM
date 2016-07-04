function [curv_ff] = dyncopy_curv(curv,n_membr,n_scales,n_orient)

    % replicate wavelet planes to n membrane
        curv_ff = cell(n_membr,n_scales-1,n_orient);
        
        for s=1:n_scales-1
            for o=1:n_orient
                for ff=1:n_membr
                    curv_ff{ff}{s}{o}=curv{s}{o};
                end
            end
        end


end

