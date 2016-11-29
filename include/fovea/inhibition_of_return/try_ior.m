
struct.gaze_params.orig_width = 300;
struct.gaze_params.orig_height = 200;
struct.gaze_params.fov_x = round(struct.gaze_params.orig_width/2);
struct.gaze_params.fov_y = round(struct.gaze_params.orig_height/2);
struct.gaze_params.img_diag_angle = degtorad(35);
struct.gaze_params.ior_factor_ctt = 2;
struct.gaze_params.ior_angle = degtorad(4);
struct.zli_params.n_membr = 10;
struct.zli_params.n_iter = 10;
map_in = zeros(200,300);

while(true)
for t=1:struct.zli_params.n_membr
    for i=1:struct.zli_params.n_iter
        map_out = apply_ior(map_in,t,i, struct);
        %figure,
        pause(0.1);
        imagesc(map_out);
        colorbar;
        xlabel(['t=' num2str(t) ',' 'iter=' num2str(i)]);
    end
end
end
close all;

