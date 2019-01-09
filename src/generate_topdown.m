function [ conf_struct ] = generate_topdown( input_image, image_props, conf_struct_path_name , conf_struct)

if nargin < 1,    
    input_image=im2double(imread('input_tsotsos/111.jpg'));
end
if nargin < 2, 
    image_props.input_folder='input_tsotsos';
    image_props.image_name_noext='111';
end
if nargin < 3,
   conf_struct_path_name='swam_max_topdown_single_config_b1_15_fusion2'; 
end
if nargin < 4, 
   conf_struct.search_params.topdown=1; 
   conf_struct.color_params.gamma=2.4;
    conf_struct.color_params.srgb_flag=1;
    conf_struct.wave_params.multires='a_trous';
    conf_struct.wave_params.ini_scale=1;
    conf_struct.wave_params.fin_scale_offset=1;
    conf_struct.wave_params.mida_min=8;
    conf_struct.wave_params.extra=3;
    conf_struct.gaze_params.foveate=0;
    conf_struct.zli_params.n_membr=10;
    conf_struct.zli_params.bScaleDelta=1;
    conf_struct.zli_params.Delta=15;
    conf_struct.resize_params.autoresize_ds=-1;
    conf_struct.resize_params.autoresize_nd=0;
    conf_struct.gaze_params.orig_height=size(input_image,1);
    conf_struct.gaze_params.orig_width=size(input_image,2);
    conf_struct.gaze_params.fov_x=round(conf_struct.gaze_params.orig_width.*0.5);
    conf_struct.gaze_params.fov_y=round(conf_struct.gaze_params.orig_height.*0.5);
        
    conf_struct.search_params.method='coefficients';
%     conf_struct.search_params.normalize=1;
    conf_struct.search_params.topdown=1;
%     conf_struct.search_params.nonzeros=1;
end




if conf_struct.search_params.topdown==1
   search_params_folder=[image_props.input_folder '/' 'target_features' '/' conf_struct_path_name];
   search_params_path=[search_params_folder '/' image_props.image_name_noext '.mat' ];
   if exist(search_params_path,'file')%leer mat con parametros channel, scale, orient, polarity 
        target_features=load(search_params_path);
        conf_struct.search_params.channels=target_features.matrix_in.channels;
        conf_struct.search_params.scales=target_features.matrix_in.scales;
        conf_struct.search_params.orientations=target_features.matrix_in.orientations;
        conf_struct.search_params.polarity=target_features.matrix_in.polarity;
        conf_struct.search_params.coefficients=target_features.matrix_in.coefficients;
   else %si no existe, generar coeficientes
       mask_path=[image_props.input_folder '/' 'masks' '/' image_props.image_name_noext '.png' ];
       if exist(mask_path,'file')
            target_features=template2params( input_image, imread(mask_path),conf_struct );
            matrix_in=target_features;
            mkdir(search_params_folder);
            save(search_params_path,'matrix_in');
            target_features=load(search_params_path);
            conf_struct.search_params.channels=target_features.matrix_in.channels;
            conf_struct.search_params.scales=target_features.matrix_in.scales;
            conf_struct.search_params.orientations=target_features.matrix_in.orientations;
            conf_struct.search_params.polarity=target_features.matrix_in.polarity;
            conf_struct.search_params.coefficients=target_features.matrix_in.coefficients;
       else
            conf_struct.search_params.topdown=0;    
       end
   end
end

end

