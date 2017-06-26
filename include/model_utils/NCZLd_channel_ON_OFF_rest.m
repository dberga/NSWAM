function [iFactor_single, iFactor_out, x_on,x_off, y_on, y_off] = NCZLd_channel_ON_OFF_rest(struct, x_on, x_off, y_on, y_off)
            if struct.gaze_params.conserve_dynamics_rest == 1
                zeros_curv = cell(1,struct.wave_params.fin_scale); 
                for s=1:struct.wave_params.fin_scale
                    for o=1:struct.wave_params.n_orient
<<<<<<< HEAD
<<<<<<< HEAD
                        zeros_curv{s}(:,:,o)=zeros(size(x_on,1),size(x_on,2));
=======
                        zeros_curv{s}(:,:,o)=zeros(struct.gaze_params.height,struct.gaze_params.width);
>>>>>>> c4b1aa4d5188e0b2705c1a16a223be6c0516437f
=======
                        zeros_curv{s}(:,:,o)=zeros(struct.gaze_params.height,struct.gaze_params.width);
>>>>>>> c4b1aa4d5188e0b2705c1a16a223be6c0516437f
                    end
                end
                struct.zli_params.n_membr = 3; %set time of rest

                [iFactor_single, iFactor_out, x_on,x_off, y_on, y_off] =NCZLd_channel_ON_OFF(zeros_curv,struct,x_on, x_off, y_on, y_off);
                  
            else
            
            iFactor_out = 0;
            iFactor_single = 0;
            
            end
end

