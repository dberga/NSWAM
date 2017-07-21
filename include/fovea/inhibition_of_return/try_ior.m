
close all;

figure(1); cla; hold on;
for ctt=0.9900:0.0001:1
    color = rand(1,3);
     factor = ones(1,1000);
    for count=2:1000
        factor(1,count) = get_ior_factor(factor(1,count-1),ctt);
    end
    plot(1:1000,factor,'color',color); 
end


struct.gaze_params.orig_width = 300;
struct.gaze_params.orig_height = 200;
struct.gaze_params.fov_x = round(struct.gaze_params.orig_width/2);
struct.gaze_params.fov_y = round(struct.gaze_params.orig_height/2);
struct.gaze_params.img_diag_angle = degtorad(35);
struct.gaze_params.ior_factor_ctt = nthroot(0.01,3000);
struct.gaze_params.ior_slope_ctt = 1;
struct.gaze_params.ior_angle = degtorad(4);
struct.zli_params.n_membr = 10;
struct.zli_params.n_iter = 10;
struct.wave_params.fin_scale=8;
struct.wave_params.ini_scale=1;
max_scale=repmat(8:-1:1,1,40);
map_in = zeros(200,300);
n_scans = 40;


gaussian_inhibition = zeros(struct.gaze_params.orig_height,struct.gaze_params.orig_width);
inhibition_factor = zeros(struct.gaze_params.orig_height,struct.gaze_params.orig_width);

figure(2);
for k=1:n_scans
    max_s = max_scale(k);
    %max_s = round(rand(1)*7)+1;
    %ior_angle = struct.gaze_params.ior_angle * (2^(max_s-1));
    ior_angle = max_s;
    gaussian_inhibition = get_ior_gaussian( struct.gaze_params.fov_x, struct.gaze_params.fov_y, 1, max_s,struct.wave_params.ini_scale,struct.wave_params.fin_scale, struct.gaze_params.orig_height , struct.gaze_params.orig_width , struct.gaze_params.img_diag_angle);
    inhibition_factor = inhibition_factor+gaussian_inhibition;
    for t=1:struct.zli_params.n_membr
        for i=1:struct.zli_params.n_iter
            inhibition_factor = get_ior_factor( inhibition_factor, struct.gaze_params.ior_factor_ctt );
            imagesc(inhibition_factor,[0,1]); %imshow(normalize_minmax(inhibition_factor));
            colorbar;
            xlabel(['gaze=' num2str(k) ',' 't=' num2str(t) ',' 'iter=' num2str(i)]);
        end
    end
    struct.gaze_params.fov_x = round(rand()*(struct.gaze_params.orig_width-1))+1;
    struct.gaze_params.fov_y = round(rand()*(struct.gaze_params.orig_height-1))+1;
end


