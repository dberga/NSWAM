function [ zctr ] = calc_zctr( w, struct)

Delta_final = round(struct.zli.Delta / struct.zli.reduccio_JW);
Delta_final = Delta_final * 2; %radius to diameter
 
window_sizes = [Delta_final Delta_final];

zctr = cell(1,struct.wave.n_scales-1);
for s=1:struct.wave.n_scales-1
    for o=1:struct.wave.n_orient
        zctr{s}(:,:,o) = relative_contrast(w{s}(:,:,o),o,window_sizes); 
    end
end


end

