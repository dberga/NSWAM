function [ outfig ] = plot_bar( y,yLabel,Legend,Title )
    if nargin < 4, Title={}; end
    if nargin < 3, Legend={}; end
    if nargin < 2, yLabel={}; end
    
    close all;
    if length(Legend)>0
%         bar(x',y','LineWidth', 2);
        outfig=bar(y','LineWidth', 2,'BarWidth',15);
        ylabel(yLabel);
        if length(Legend) > 1
            legend(Legend);
        end
    else
        outfig=bar(y','LineWidth', 2);
        ylabel(yLabel);
    end
    
%     xsep=abs(x(1,1)-x(1,2)).*0.5;
    
%      xlim([min(x(:))-xsep max(x(:))+xsep]);
    %ylim([min(y) max(y)]);
    title(Title);
end

