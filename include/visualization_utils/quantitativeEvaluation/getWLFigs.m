function [  ] = getWLFigs( Fws, Sws, Fwname, Swname )
        if nargin<4,  Swname='Relative Saliency (Weber Contrast)'; end;
        if nargin<3,  Fwname='Feature Contrast'; end;
        
        colormap = rand(length(Fws),3);
        figure;
        plot(Fws,Sws,'-x','color',colormap(1,:),'LineWidth',1.5);

        ylabel( sprintf(Swname) , 'FontSize', 11);
        xlabel( sprintf(Fwname) , 'FontSize', 11);
        
        title(sprintf(['Nonlinearity of saliency perception with respect to ' Fwname]), 'FontSize', 12);

        paperPosition=[0 0 7.2 6];
        set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
        %print(gcf,'-depsc2', sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir ,flag_exp, algrt.nome{indexAltg},fr));
        %saveas(gcf, sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir , flag_exp, algrt.nome{indexAltg},fr), 'jpg');
        
end

