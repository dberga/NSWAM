function []=Mostrar_curv_frame(curv,ff)

% figure,imagesc(curv{1}{1}{orient});colormap('gray');

figure;

Dx=0;
Dy=0;

n_ff=size(curv,1);
nplans=size(curv{1},2);
n_orient_max=size(curv{1}{1},2);
seq=1;
for s=1:nplans
    n_orient=size(curv{1}{s},2);
    for o=1:n_orient
        subplot(nplans,n_orient_max,seq),imagesc(curv{ff}{s}{o});colormap('gray');
        seq=seq+1
    end
end


end