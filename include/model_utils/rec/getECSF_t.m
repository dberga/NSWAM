
function [ecsf] = getECSF_t(iFactor, struct, channel)

	ecsf = channel_calceCSF(iFactor,struct.wave.n_scales,struct.wave.ini_scale,struct.wave.fin_scale,struct.zli.n_membr,channel, struct.csfparams.nu_0, struct.csfparams.params_intensity,struct.csfparams.params_chromatic);

end


function [eCSF] = channel_calceCSF(iFactor,n_scales,ini_scale,fin_scale,n_membr,channel, nu_0, csf_params_intensity, csf_params_chromatic)


    % e-CSF (experimental part, no modification by default)
    eCSF=cell([n_scales,1]);

        for scale=ini_scale:fin_scale
            n_orient=size(iFactor{scale},2);
            eCSF{scale} = cell([n_orient,1]);
            for o=1:n_orient
    %             		curv_final{scale}{i}=curv_final{scale}{i};
    % 	      		eCSF{scale}{o}=generate_csf(iFactor{scale}{o}(:,:), scale,zli.nu_0,'intensity');
                eCSF{scale}{o}=generate_csf_givenparams(iFactor{scale}{o}(:,:), scale,nu_0,channel,csf_params_intensity,csf_params_chromatic);
                
                
                
                
                % 		curv_final{scale}{o}=curv{scale}{o}.*generate_csf(iFactor(:,:,scale,o),scale,zli.nu_0,'intensity')*0.5;
                
    %              curv_final{scale}{i}=curv_final{scale}{i}*generate_csf(0.5,scale,zli.nu_0,'intensity')*0.5;
            end
        end



end