function [ Sw  ] = getSaliencyIndex( smap, mask )

                smap=normalize_energy(smap);
                mask=normalize_energy(mask);
                
                target=smap.*mask;
                npixWin=sum(mask(:));
                Ls=sum(target(:));
                Lb = sum( smap(:));
                Lb = (Lb- Ls)/(numel(smap)-npixWin);
                Ls=Ls/npixWin;
                
                Sw=WeberLaw(Ls,Lb);
end

function [ Sw  ] = getSaliencyIndex_Spratling( smap, mask )

                smap=normalize_energy(smap);
                mask=normalize_energy(mask);
                
                target=smap.*mask;
                perif=smap.*~mask;
                max_cent=max(target(:));
                max_perif=max(perif(:));
                Sw=(max_cent-max_perif)/(max_cent+max_perif);
                
                Sw=sign(Sw).*sqrt(abs(Sw));
end




