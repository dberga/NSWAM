addpath(genpath('src'));
addpath(genpath('include'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_name='1.jpg';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output_folder_mats = 'mats';
image_name_noext = remove_extension(image_name);

channels = {'chromatic', 'chromatic2' ,'intensity'};
image_struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{1} ')' '.mat'];
c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{2} ')' '.mat'];
c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{3} ')' '.mat'];
c1_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
c2_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
c3_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{3} ')' '.mat'];

image_struct = load(image_struct_path); image_struct = image_struct.matrix_in;

c1_iFactor = load(c1_iFactorpath); c1_iFactor = c1_iFactor.matrix_in; 
c1_residual = load(c1_residualpath); c1_residual = c1_residual.matrix_in;
c1_Ls = load(c1_Lspath); c1_Ls = c1_Ls.matrix_in;
c2_iFactor = load(c2_iFactorpath); c2_iFactor = c2_iFactor.matrix_in; 
c2_residual = load(c2_residualpath); c2_residual = c2_residual.matrix_in;
c2_Ls = load(c2_Lspath); c2_Ls = c2_Ls.matrix_in;
c3_iFactor = load(c3_iFactorpath); c3_iFactor = c3_iFactor.matrix_in; 
c3_residual = load(c3_residualpath); c3_residual = c3_residual.matrix_in;
c3_Ls = load(c3_Lspath); c3_Ls = c3_Ls.matrix_in;
    
%if Ls has no rows/cols (not correct transform)
    if size(c1_Ls,1)~= image_struct.wave.n_scales || size(c2_Ls,3)~= image_struct.wave.n_scales || size(c3_Ls,3)~= image_struct.wave.n_scales
        c1_Ls = c1_residual;
        c2_Ls = c2_residual;
        c3_Ls = c3_residual;
    end
    
    
RF_ti_s_o_c = unify_channels_ti(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);
Ls_s_c = unify_channels_norient(c1_Ls,c2_Ls,c3_Ls,image_struct);

RF_s_o_c = timatrix_to_matrix(RF_ti_s_o_c,image_struct);
[RF_s,residual_s,Ls_s] = get_RF_max_t(RF_s_o_c,residual_s_c,Ls_s_c,image_struct);        
RF_s_o = repicate_orient(RF_s,image_struct);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sinit = 1;
sfinal = image_struct.wave.n_scales-1;
oinit = 1;
ofinal = image_struct.wave.n_orient;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


show_TI_s_o_matrix(c1_iFactor,1,1,sinit,sfinal,oinit,ofinal);

