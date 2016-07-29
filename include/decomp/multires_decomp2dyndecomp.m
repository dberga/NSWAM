function [ dynw, residual] = multires_decomp2dyndecomp( w, c , n_membr, n_iter, n_scales )

residual = c;
dynw = cell(n_membr, n_iter, n_scales-1);
for ff=1:n_membr
    for iter=1:n_iter
        for s=1:n_scales-1
            dynw{ff}{iter}{s} = w{s};
            %dynw{ff}{iter}{n_scales}{1} = c{n_scales-1};
        end
    end
end

end

