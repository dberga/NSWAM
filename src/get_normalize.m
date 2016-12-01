function [smap] = get_normalize(loaded_struct,smap)

    switch(loaded_struct.fusion_params.fusion)
        case 1	

              smap = normalize_energy(smap);

        case 2

              smap = normalize_Z(smap);
        case 3

            smap = normalize_Zp(smap);

        otherwise
            %do nothing
    end
            
    smap = normalize_minmax(smap); 
    
    

end


