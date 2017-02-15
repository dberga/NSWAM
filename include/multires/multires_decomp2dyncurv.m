function [ dyncurv, residual] = multires_decomp2dyncurv( w, c , n_membr, n_iter, n_scales ,n_orient)

residual = c;
dyncurv = cell(n_membr, n_iter, n_scales-1,n_orient);
for ff=1:n_membr
    for iter=1:n_iter
        for s=1:n_scales-1
            for o=1:n_orient
            dyncurv{ff}{iter}{s}{o} = w{s}(:,:,o);
            end
            %dyncurv{ff}{iter}{n_scales}{1} = c{n_scales-1};
        end
    end
end

end

