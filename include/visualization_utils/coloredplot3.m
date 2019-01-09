function h = coloredbar3( x, labels, colors,lines,markers)%, varargin )


    h = plot(x);
    for ii = length(x):-1:1
        h(ii).Color=colors{ii};
        h(ii).Marker=markers{ii};
        h(ii).LineStyle=lines{ii};
        h(ii).LineWidth=1;
    end

    %legend(labels);
    set(gca,'fontsize',12);


%     for ii = 1:2:size(varagin, 2)
%         set(h, varargin{ii}, varargin{ii+1});
%     end
    
    %xticks(1:length(labels));
    %set(gca, 'xticklabel', labels);
    %set(gca,'XTickLabelRotation',-45);
end

