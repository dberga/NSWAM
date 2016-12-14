function [smap] = get_normalize(loaded_struct,smap)

    switch(loaded_struct.fusion_params.fusion)
        case 1	
 
              smap = normalize_energy(smap); %by sum or energy

        case 2

              smap = normalize_Z(smap); %by variance or standarization
        case 3

            smap = normalize_Zp(smap); %by variance or standarization (only positives)
            
        case 4
            
            smap = normalize_range(smap); %by range
            
        case 5
            
            smap = histeq(smap);  % by histogram equalization
            
        otherwise
            %do nothing
    end
            
    smap = normalize_minmax(smap); %normalize to 0 and 1
    
    

end


