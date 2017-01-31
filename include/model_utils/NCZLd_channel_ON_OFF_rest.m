function [iFactor_single, iFactor_out, x_on,x_off, y_on, y_off] = NCZLd_channel_ON_OFF_rest(struct, x_on, x_off, y_on, y_off)
            if struct.gaze_params.conserve_dynamics_rest == 1
                zeros_curv = cell(1,struct.wave_params.fin_scale); 
                for s=1:struct.wave_params.fin_scale
                    for o=1:struct.wave_params.n_orient
                        zeros_curv{s}(:,:,o)=zeros(struct.gaze_params.height,struct.gaze_params.width);
                    end
                end
                struct.zli_params.n_membr = 3; %set time of rest

                [iFactor_single, iFactor_out, x_on,x_off, y_on, y_off] =NCZLd_channel_ON_OFF(zeros_curv,struct,x_on, x_off, y_on, y_off);
                  
            else
            
            iFactor_out = 0;
            iFactor_single = 0;
            
            end
end

