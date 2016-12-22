function [ x_on,x_off, y_on, y_off] = NCZLd_channel_ON_OFF_rest(struct,channel, x_on, x_off, y_on, y_off)
            if struct.gaze_params.conserve_dynamics_rest == 1
                zeros_curv = cell(1,struct.wave_params.fin_scale); 
                for s=1:struct.wave_params.fin_scale
                    for o=1:struct.wave_params.n_orient
                        zeros_curv{s}(:,:,o)=zeros(loaded_struct.gaze_params.height,loaded_struct.gaze_params.width);
                    end
                end
                struct.zli_params.n_membr = 3; %set time of rest
                
                [~, ~, ~, ~, ~, x_on, x_off, y_on, y_off, ~, ~] =NCZLd_channel_ON_OFF(zeros_curv,loaded_struct,loaded_struct.color_params.channels{c},last_xon, last_xoff, last_yon, last_yoff);
            end
end

