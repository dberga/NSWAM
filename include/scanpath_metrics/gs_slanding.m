function [ mean_distance, std_distance, distances  ] = gs_slanding( scanpath1, scanpath2g, gaze, ff_flags)
    if nargin<4, firstfixation_flag_default; end
    
    if iscell(scanpath1)
        scanpath1g_cell=scanpaths_gazes(scanpath1);
        scanpath1g=scanpath1g_cell{gaze};
        [mean_distance, std_distance, distances]=slanding(scanpath1g,scanpath2g,ff_flags);
    else
        
        scanpath1g=repmat(scanpath1(gaze,:),size(scanpath2g,1),1);
        [mean_distance, std_distance, distances]=slanding(scanpath1g,scanpath2g,ff_flags);
    end
    
end


