
function [ecsf] = getECSF_t(iFactor, struct, channel)

	ecsf = channel_calceCSF(iFactor,struct.wave_params.n_scales,struct.wave_params.ini_scale,struct.wave_params.fin_scale,channel, struct.csf_params.nu_0, struct.csf_params.params_intensity,struct.csf_params.params_chromatic);

end


function [eCSF] = channel_calceCSF(iFactor,n_scales,ini_scale,fin_scale,channel, nu_0, csf_params_intensity, csf_params_chromatic)


    % e-CSF (experimental part, no modification by default)
    eCSF=cell([n_scales,1]);

        for scale=ini_scale:fin_scale
            n_orient=size(iFactor{scale},2);
            eCSF{scale} = cell([n_orient,1]);
            for o=1:n_orient
    %             		curv_final{scale}{i}=curv_final{scale}{i};
    % 	      		eCSF{scale}{o}=generate_csf(iFactor{scale}{o}(:,:), scale,zli_params.nu_0,'intensity');
                eCSF{scale}{o}=generate_csf_givenparams(iFactor{scale}{o}(:,:), scale,nu_0,channel,csf_params_intensity,csf_params_chromatic);
                
                
                
                
                % 		curv_final{scale}{o}=curv{scale}{o}.*generate_csf(iFactor(:,:,scale,o),scale,zli_params.nu_0,'intensity')*0.5;
                
    %              curv_final{scale}{i}=curv_final{scale}{i}*generate_csf(0.5,scale,zli_params.nu_0,'intensity')*0.5;
            end
        end



end