function [ outfig ] = plot_bar( x,y,xLabel,yLabel,Legend,Title )
    if nargin < 6, Title={}; end
    if nargin < 5, Legend={}; end
    if nargin < 4, xLabel={}; end
    if nargin < 3, yLabel={}; end
    
    if size(x,1) < size(y,1)
        x=repmat(x,size(y,1),1);
    end
    
    close all;
    if length(Legend)>0
%         bar(x',y','LineWidth', 2);
        outfig=bar(x',y','LineWidth', 2);
        xlabel(xLabel);
        ylabel(yLabel);
        if length(Legend) > 1
            legend(Legend);
        end
    else
        outfig=bar(x',y','LineWidth', 2);
        xlabel(xLabel);
        ylabel(yLabel);
    end
    
    xsep=abs(x(1,1)-x(1,2)).*0.5;
    
     xlim([min(x(:))-xsep max(x(:))+xsep]);
    %ylim([min(y) max(y)]);
    title(Title);
end

