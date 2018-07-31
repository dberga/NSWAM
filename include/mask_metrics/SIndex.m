function [ Sw  ] = SIndex( smap, mask )

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




