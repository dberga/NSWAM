function [] = NCZLd(img, nomexperiment, struct)


% refactor of general_NCZLd, NCZLd and NCZLd_channel


img = double(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% START - TIC! %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time
t_ini=tic;
devlog(int2str(size(img(:,:,1))) );



          
%-------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calc scales and orient %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%if n_scales = 0
[struct.wave.n_scales, struct.wave.ini_scale, struct.wave.fin_scale]= calc_scales(img, struct.wave.ini_scale, struct.wave.fin_scale_offset, struct.wave.mida_min, struct.wave.multires); % calculate number of scales (n_scales) automatically

[struct.wave.n_orient] = calc_norient(img,struct.wave.multires,struct.wave.n_scales,struct.zli.n_membr);
devlog(strcat('Nombre scales a la funci channel_v1_0: ', num2str(struct.wave.n_scales)));

%-------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Plot and store  struct %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

store_matrix_givenparams(struct,'struct',struct);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%  stimulus (image) to opponent, also get name %%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


img = get_the_cstimulus(img,struct.image.gamma,struct.image.srgb_flag);%! color  to opponent


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NCZLd for every channel %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


channel_type={'chromatic', 'chromatic2', 'intensity'};
for op=1:3
    
    channel = channel_type{op};
    disp(['channel=' channel]);
    im_opponent = img(:,:,op);
    
    im_opponent_dynamic = dynrep_channel(im_opponent,struct.zli.n_membr); %if static, replicate frames
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% wavelet decomposition %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [curv, w, c, Ls] = multires_dispatcher(im_opponent_dynamic, struct.wave.multires,struct.wave.n_scales, struct.zli.n_membr);

    [curv] = dyncopy_curv(curv,struct.wave.n_scales,struct.zli.n_membr); %! duplicitat, s'hauria de fer a NCZLd


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% store dwt (curv) %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    if struct.image.tmem_rw_res == 1
    if struct.display_plot.store_irrelevant==1
    %store_matrix_givenparams_channel(curv,'omega',channel,struct);
    store_matrix_givenparams_channel(curv,'omega',channel,struct);
    end
    end
    store_matrix_givenparams_channel(c,'residual',channel,struct);
    store_matrix_givenparams_channel(Ls,'Ls',channel,struct);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% apply neurodinamic %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic

    [curv_final, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] =NCZLd_channel_ON_OFF_v1_1(curv,struct,channel);
    iFactor = curv_final;
    
    toc
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% store iFactor %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    store_matrix_givenparams_channel(iFactor,'iFactor',channel,struct);

    if struct.image.tmem_rw_res == 1
        iFactor_meanized = tmatrix_to_matrix(iFactor,struct,1);
        display_matrix_channel(iFactor_meanized,'iFactor_res',channel,struct);
        store_matrix_givenparams_channel(iFactor_meanized,'iFactor',channel,struct);
    end
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% END - TOC! %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time
toc(t_ini)
end


%---























