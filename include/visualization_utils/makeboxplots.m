function [ h ] = makeboxplots( cell_in , boxlabels)
    if nargin < 2, boxlabels=num2cell(min(1,length(cell_in)):length(cell_in)); end

close all;
[x,group]=cell2arraywgroup(cell_in);
h=boxplot(x,group,'Colors',[0 0 0],'Widths',0.75,'Labels',boxlabels);


end

