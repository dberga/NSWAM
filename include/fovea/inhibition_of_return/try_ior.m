
close all;

figure(2); cla; hold on;
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
struct.gaze_params.ior_factor_ctt = 0.999;
struct.gaze_params.ior_slope_ctt = 1;
struct.gaze_params.ior_angle = degtorad(4);
struct.zli_params.n_membr = 10;
struct.zli_params.n_iter = 10;
map_in = zeros(200,300);
n_scans = 10;


gaussian_inhibition = zeros(struct.gaze_params.orig_height,struct.gaze_params.orig_width);
inhibition_factor = zeros(struct.gaze_params.orig_height,struct.gaze_params.orig_width);

figure(1);
for k=1:n_scans
    gaussian_inhibition = get_ior_gaussian(struct.gaze_params.fov_x, struct.gaze_params.fov_y, 1, struct.gaze_params.ior_angle, struct.gaze_params.orig_height, struct.gaze_params.orig_width, struct.gaze_params.img_diag_angle);
    inhibition_factor = inhibition_factor+gaussian_inhibition;
    for t=1:struct.zli_params.n_membr
        for i=1:struct.zli_params.n_iter
            inhibition_factor = get_ior_factor( inhibition_factor, struct.gaze_params.ior_factor_ctt );
            pause(0.01);
            imagesc(inhibition_factor);
            colorbar;
            xlabel(['gaze=' num2str(k) ',' 't=' num2str(t) ',' 'iter=' num2str(i)]);

        end
    end
    struct.gaze_params.fov_x = round(rand()*struct.gaze_params.orig_width);
    struct.gaze_params.fov_y = round(rand()*struct.gaze_params.orig_height);
end


