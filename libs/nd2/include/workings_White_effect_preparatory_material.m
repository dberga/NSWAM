% preparatory material for a new figure


load whi_256_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_curv_ON.mat
load whi_256_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_curv_OFF.mat

load grating_256_min_freq_32_epsilon_1.3_kappay_1.35_normal_output_2_curv

% curv_ON and curv_OFF are 1x20 cells constant along the 20 dimensions
a=curv_ON{1};
b=curv_OFF{1};

% horizontal
o=1;
for s=1:4
    figure
    subplot(1,2,1)
    imagesc(a(:,:,s,o));colormap gray
    title(['ON, horizontal, scale ' num2str(s)])
    subplot(1,2,2)
    imagesc(b(:,:,s,o));colormap gray
    title(['OFF, horizontal, scale ' num2str(s)])
end   

% vertical
o=2;
for s=1:4
    figure
    subplot(1,2,1)
    imagesc(a(:,:,s,o));colormap gray
    title(['ON, horizontal, scale ' num2str(s)])
    subplot(1,2,2)
    imagesc(b(:,:,s,o));colormap gray
    title(['OFF, horizontal, scale ' num2str(s)])
end   

% diagonal
o=3;
for s=1:4
    figure
    subplot(1,2,1)
    imagesc(a(:,:,s,o));colormap gray
    title(['ON, horizontal, scale ' num2str(s)])
    subplot(1,2,2)
    imagesc(b(:,:,s,o));colormap gray
    title(['OFF, horizontal, scale ' num2str(s)])
end   