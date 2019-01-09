function [  ] = getFigsData( Dat,Fwname )
            
            figure1=figure('Position', [100, 100, numel(Dat)*300, 800]);
            for indexImg = 1:numel(Dat)
                
                %Firts row
                subplot(3,numel(Dat),indexImg),
                imshow(Dat(indexImg).im,[]);
                [~,cond,~]=fileparts(fileparts(Dat(indexImg).nomeimg)); 
                xlabel(cond);
                freezeColors;
                %second row
                subplot(3,numel(Dat),indexImg+numel(Dat)),
                imshow(Dat(indexImg).mapsal,[Dat(indexImg).min Dat(indexImg).max]); 
                %colormap(jet);
                %freezeColors;
                %xlabel(sprintf('MaxSal =%.4e,Sindex=%.4e',Dat(indexImg).max,Dat(indexImg).sw));
                xlabel(sprintf('Sindex=%.4e',Dat(indexImg).sw));
                
                
            end
            subplot(3,numel(Dat),[1:numel(Dat)]+[numel(Dat)*2]),
            bar([Dat(:).sw]);
            %ylim([min([Dat(:).sw]) max([Dat(:).sw])]);
            
            mtit(Fwname,'fontsize',15,'color',[1 0 0]);
            %[pathstr, name, ext] = fileparts(im_dir{flag_exp});
            %saveas(gcf, sprintf('%s/%s_%s_fr%.1f.jpg', fig_dir ,strtok(name,'_'),algrt.nome{indexAltg},fr), 'jpg');
            %close;
            
      
end

