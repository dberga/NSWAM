function [ smap ] = get_smooth( smap, conf_struct )

        if ~exist('conf_struct.fusion_params.gsp','var'), conf_struct.fusion_params.gsp=0;  end
        
        if conf_struct.fusion_params.gsp ~= 0
            sigval=max(size(smap))*conf_struct.fusion_params.gsp*0.01;
            sigwin=[round(6*sigval) round(6*sigval)];
            smap=filter2(fspecial('gaussian',sigwin,sigval),mean_smap);
        end
end

