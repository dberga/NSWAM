function [eCSFMitja]=calcular_eCSFMitja(eCSF,n_iter,n_scales,n_orient)
% n_iter = 100;
% scale = 1;
% orient = 1;

for iter=1:1
    for scale=1:n_scales
        for o=1:n_orient
            eCSFMitja{scale}{o}=eCSF{iter}{scale}{o};
        end
    end
end
% figure;
for iter=2:n_iter
    for scale=1:n_scales
        for o=1:n_orient
            eCSFMitja{scale}{o} = eCSFMitja{scale}{o} + eCSF{iter}{scale}{o};
%     imagesc(iFactor{iter}(:,:,scale,orient));colormap('gray');
%     min(iFactor{iter}(:,:,scale,orient));
%     max(iFactor{iter}(:,:,scale,orient));
        end
    end
end
for scale=1:n_scales
    for o=1:n_orient
        eCSFMitja{scale}{o}=eCSFMitja{scale}{o}./n_iter;
    end
end

% figure,imagesc(iFactorMig(:,:,scale,orient));colormap('gray');

end
