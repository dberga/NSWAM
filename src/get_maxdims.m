function [ RFmax_unfov,RFmax,residualmax,max_mempotential_val,fov_y,fov_x,maxidx_y,maxidx_x,maxidx_s,maxidx_o,maxidx_c] = get_maxdims( RF_s_o_c , residual_s_c,loaded_struct)
RF_c_s_o = soc2cso(RF_s_o_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
residual_c_s = sc2cs(residual_s_c,3,loaded_struct.wave_params.n_scales); 

[ RFmax, residualmax,maxidx_s, maxidx_o, maxidx_c, maxidx_x, maxidx_y] = get_wavet_max_t( RF_s_o_c, residual_s_c, loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient, 3 );
max_mempotential_val=RFmax(maxidx_y,maxidx_x);

if loaded_struct.gaze_params.foveate ~= 0
    RFmax_unfov=foveate(RFmax,1,loaded_struct);
else
    RFmax_unfov = RFmax;
end

[~,maxidx_fov]=max(RFmax_unfov(:));


%% modulate SA
%loaded_struct.gaze_params.modulateSA=1;
if loaded_struct.gaze_params.modulateSA==1
    [carty,cartx]=meshgrid(1:size(RFmax_unfov,1), 1:size(RFmax_unfov,2));
    SA_px = sqrt((carty-loaded_struct.gaze_params.fov_y).^2 + (cartx-loaded_struct.gaze_params.fov_x).^2);
    SA_deg = SA_px ./ rad2deg(loaded_struct.gaze_params.img_diag_angle);
    PSA=get_saccadeamplitude_probability(SA_deg);
    RFmax_unfov=RFmax_unfov*PSA;
end
[fov_y,fov_x]=ind2sub(size(RFmax_unfov),maxidx_fov);

end

