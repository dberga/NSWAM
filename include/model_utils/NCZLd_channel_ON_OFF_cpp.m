function [iFactor_single,iFactor_out, x_on,x_off, y_on, y_off] = NCZLd_channel_ON_OFF_cpp(w,struct, x_on, x_off, y_on, y_off)

    
[ x_on, ~ ] = multires_multidim2decomp( x_on, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ x_off, ~ ] = multires_multidim2decomp( x_off, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ y_on, ~ ] = multires_multidim2decomp( y_on, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ y_off, ~ ] = multires_multidim2decomp( y_off, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );

%struct.zli_params.n_membr = 2;
%struct.zli_params.ON_OFF = 0;


[iFactor_single, iFactor_out, x_on, x_off, y_on, y_off] = NCZLd_periter_mex(w,struct, x_on, x_off, y_on, y_off);

%disp('done2');

[ x_on, ~ ] = multires_decomp2multidim( x_on, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ x_off, ~ ] = multires_decomp2multidim( x_off, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ y_on, ~ ] = multires_decomp2multidim( y_on, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );
[ y_off, ~ ] = multires_decomp2multidim( y_off, 0, struct.wave_params.n_scales, struct.wave_params.n_orient );

%disp('done4');

end
