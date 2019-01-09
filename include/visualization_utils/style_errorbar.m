function [ infig ] = style_errorbar( infig, colors, symbols, linestyle, linewidth, markersize)
    if nargin < 6, markersize=8; end
    if nargin < 5, linewidth=2; end
    if nargin < 4, 
        for cbc=1:length(infig)
            linestyle(cbc,:)='-';
        end
    end
    if nargin < 3, 
        totalsymbols=['s';'o';'d';'*';'+';'x';'.';'p';'h'];
        for cbc=1:length(infig)
            symbols(cbc,:)='s';
        end
    end
    if nargin < 2,
       totalcolors=['r';'m';'g';'y';'c';'w';'b';'k'];
       for cbc=1:length(infig)
            colors(cbc,:)=totalcolors(cbc,:);
       end
    end
    
    for cbc=1:length(infig)
        set(infig(cbc),'Color', colors(cbc,:));
        set(infig(cbc),'Marker', symbols(cbc,:));
        set(infig(cbc),'MarkerSize', markersize);
        set(infig(cbc),'LineStyle', linestyle{cbc,1});
        set(infig(cbc),'LineWidth', linewidth);
        set(infig(cbc),'MarkerFaceColor', colors(cbc,:));
    end
     
end

