function [ outfig ] = boxplot_addasterisks( comparison)
    
    siggroups=find(comparison(:,6)<0.05);
    it=1;
    for sg=1:length(siggroups)
        stargroups{it}=comparison(siggroups(sg),1:2);
        sigstats(it)=comparison(siggroups(sg),6);
        it=it+1;
    end
    sigstar(stargroups,sigstats);
    outfig=gca;
end

