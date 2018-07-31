function [ Sw  ] = SIndex_Spratling( smap, mask )

                smap=normalize_energy(smap);
                mask=normalize_energy(mask);
                
                target=smap.*mask;
                perif=smap.*~mask;
                max_cent=max(target(:));
                max_perif=max(perif(:));
                Sw=(max_cent-max_perif)/(max_cent+max_perif);
                
                Sw=sign(Sw).*sqrt(abs(Sw));
end

