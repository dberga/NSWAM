function [ figs  ] = show_RF_dynamic( matrix, tinit, tfinal, iterinit, iterfinal, sinit, sfinal, oinit, ofinal )


            for t=tinit:tfinal
                for iter=iterinit:iterfinal
                    %set(gcf, 'Position', get(0,'Screensize'));
                    %title('RF');
                    %xlabel(['orient ' int2str(oinit) '...' int2str(ofinal) ]);
                    %ylabel(['scales ' int2str(sinit) '...' int2str(sfinal) ]);
                    
                    figure; h = show_RF(matrix, t,iter,sinit,sfinal,oinit,ofinal );
                    figs(iter+(t*10-10)) = h;
                    
                end
            end
        
end

