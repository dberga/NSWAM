function [mean_distance ,std_distance,distances ] = gbg_slanding( scanpath1, scanpath2, gaze, ff_flags )
    if nargin<4, firstfixation_flag_default; end
    
    if iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1{p}(gaze,:),scanpath2{p}(gaze,:),ff_flags);
        end
        for p=1:length(scanpath1)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
%            for g=1:length(all_distances{p})
                distances{gaze}=[distances{gaze}; all_distances{p}(gaze)];
%             end 
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=nanmean(cell2mat(distances));
    elseif iscell(scanpath1) && ~iscell(scanpath2)
        for p=1:length(scanpath1)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1{p}(gaze,:),scanpath2(gaze,:),ff_flags);
        end
        for p=1:length(scanpath1)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
%            for g=1:length(all_distances{p})
                 distances{gaze}=[distances{gaze}; all_distances{p}(gaze)];
%             end 
        end
        
        mean_distance=nanmean(cell2mat(all_mean_distance));
        std_distance=nanmean(cell2mat(all_std_distance));
        distances=nanmean(cell2mat(distances));
        
    elseif ~iscell(scanpath1) && iscell(scanpath2)
        for p=1:length(scanpath2)
            [all_mean_distance{p},all_std_distance{p},all_distances{p}]=slanding(scanpath1(gaze,:),scanpath2{p}(gaze,:),ff_flags);
        end
        for p=1:length(scanpath2)
           if ~exist('distances')
               distances=cell(1,length(all_distances{p}));
           end
%            for g=1:length(all_distances{p})
                 distances{gaze}=[distances{gaze}; all_distances{p}(gaze)];
%             end 
        end
        
        mean_distance=mean(cell2mat(all_mean_distance));
        std_distance=mean(cell2mat(all_std_distance));
        distances=mean(cell2mat(distances));
    else
        [mean_distance,std_distance,distances]=slanding(scanpath1(gaze,:),scanpath2(gaze,:),ff_flags);
    end


end

