
close all;


struct.gaze_params.orig_width = 300;
struct.gaze_params.orig_height = 200;
struct.gaze_params.fov_x = round(struct.gaze_params.orig_width/2);
struct.gaze_params.fov_y = round(struct.gaze_params.orig_height/2);
struct.gaze_params.img_diag_angle = degtorad(35);
struct.gaze_params.ior_factor_ctt = 2;
struct.gaze_params.ior_slope_ctt = 1;
struct.gaze_params.ior_angle = degtorad(4);
struct.zli_params.n_membr = 10;
struct.zli_params.n_iter = 10;
map_in = zeros(200,300);



figure(2);cla; hold on; for s=1:10; color = rand(1,3); plot(0.1:0.1:1,get_ior_factor(1:struct.zli_params.n_membr,struct.zli_params.n_membr,1:struct.zli_params.n_iter,struct.zli_params.n_iter,s),'color',color); end;

while(true)
for t=1:struct.zli_params.n_membr
    for i=1:struct.zli_params.n_iter
        map_out = apply_ior(map_in,t,i, struct);
        figure(1);
        pause(0.1);
        imagesc(map_out);
        colorbar;
        xlabel(['t=' num2str(t) ',' 'iter=' num2str(i)]);
        
    end
end
end


