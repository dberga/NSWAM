function h = coloredbar3( x, labels, colors)%, varargin )
%Coloredbar - create a bar chart with passed in colours
%   x - vector of values for bar heights
%   labels - vector of strings for bar labels
%   colors - vector of color specs for bar colours
%   ... - additional value argument paris for bar chart
%  
% Returns: handle to bar object
%
%     if(~isvector(x))
%         error('coloredbar currently only accepts single series\n');
%     end
    h = bar3(x);
    for ii = length(x):-1:1
        h(ii).FaceColor=colors{ii};
    end
    xticks(1:length(labels));
    set(gca, 'xticklabel', labels);
    set(gca,'XTickLabelRotation',-45);
    set(gca,'fontsize',8);
%     for ii = 1:2:size(varagin, 2)
%         set(h, varargin{ii}, varargin{ii+1});
%     end

end

