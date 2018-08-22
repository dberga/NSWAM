function [residuals] = get_residual_updated(loaded_struct,residuals)
            switch loaded_struct.fusion_params.residual_wave
                case 0
                    for s=1:length(residuals)
                        %disp(residuals{s});
                        residuals{s} = zeros(size(residuals{s}));
                    end
                case 1
                    for s=1:length(residuals)
                        residuals{s} = zeros(size(residuals{s})) +1;
                    end
                otherwise
                    %keep it as it is
            end
end
