function [ mean_distance, std_distance, distances ] = pp_slanding( scanpath1, scanpath2, ff_flags )
    if nargin<3, firstfixation_flag_default; end
    
    if iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=accumsa(scanpath1{p},scanpath2{p},ff_flags);
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
        for g=1:length(distances)
            distances_alt(g)=nanmean(distances{g});
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=distances_alt;
        
    elseif iscell(scanpath1) && ~iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=accumsa(scanpath1{p},scanpath2,ff_flags);
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
        for g=1:length(distances)
            distances_alt(g)=nanmean(distances{g});
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=distances_alt;
        
    elseif ~iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath2)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=accumsa(scanpath1,scanpath2{p},ff_flags);
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
        for g=1:length(distances)
            distances_alt(g)=nanmean(distances{g});
        end
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=distances_alt;
    else
        [mean_distance,std_distance,distances]=accumsa(scanpath1,scanpath2,ff_flags);
    end

end

