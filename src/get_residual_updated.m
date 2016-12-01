function [residuals] = get_residual_updated(loaded_struct,residuals)
            switch loaded_struct.fusion_params.residual_wave
                case 0
                    for s=1:loaded_struct.wave_params.n_scales-1
                        residuals{s} = zeros(size(residuals{s}));
                    end
                case 1
                    for s=1:loaded_struct.wave_params.n_scales-1
                        residuals{s} = zeros(size(residuals{s})) +1;
                    end
                otherwise
                    %keep it as it is
            end
end
