function [ mean_distance, std_distance, distances ] = pp_slanding( scanpath1, scanpath2 )
    
    if iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1{p},scanpath2{p});
        end
        for p=1:length(scanpath1)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
           for g=1:length(all_distances{p})
               if length(all_distances{p}) <= length(distances)
                    distances{g}=[distances{g}, all_distances{p}(g)];
               else
                   distances{g}=[all_distances{p}(g)];
               end
            end 
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=nanmean(cell2mat(distances));
    elseif iscell(scanpath1) && ~iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1{p},scanpath2);
        end
        for p=1:length(scanpath1)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
           for g=1:length(all_distances{p})
               if length(all_distances{p}) <= length(distances)
                    distances{g}=[distances{g}, all_distances{p}(g)];
               else
                   distances{g}=[all_distances{p}(g)];
               end
            end
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=nanmean(cell2mat(distances));
        
    elseif ~iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath2)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1,scanpath2{p});
        end
        for p=1:length(scanpath2)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
           for g=1:length(all_distances{p})
               if length(all_distances{p}) <= length(distances)
                    distances{g}=[distances{g}, all_distances{p}(g)];
               else
                   distances{g}=[all_distances{p}(g)];
               end
            end 
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=nanmean(cell2mat(distances));
    else
        [mean_distance,std_distance,distances]=slanding(scanpath1,scanpath2);
    end

end

