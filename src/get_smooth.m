function [ smap ] = get_smooth( smap, conf_struct )

        if ~isfield(conf_struct.fusion_params,'gsp'), conf_struct.fusion_params.gsp=0;  end
        
        if conf_struct.fusion_params.gsp ~= 0
              smap=zhong2012(smap,conf_struct.fusion_params.gsp*radtodeg(conf_struct.gaze_params.img_diag_angle));
              smap=normalize_minmax(smap);
        end
        
end

