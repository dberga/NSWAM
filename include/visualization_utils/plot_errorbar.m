function [ outfig ] = plot_errorbar( x,y,err,xLabel,yLabel,Legend,Title)
    if nargin < 7, Title={}; end
    if nargin < 6, Legend={}; end
    if nargin < 5, xLabel={}; end
    if nargin < 4, yLabel={}; end
    
        
    close all;
    if length(Legend)>0
        hold on;
        for l=1:length(Legend)
            outfig(l)=errorbar(x(:,1),y(:,l),err(:,l),'-o','LineWidth', 2);
            
        end
        hold off;
        if length(Legend) > 1
            legend(Legend);
        end
    else
        outfig=errorbar(x,y,'LineWidth', 2);
    end
    
    
    

    ylabel(yLabel);
    
    xlabel(xLabel{1});
    mindiff=min(abs(x(1,1)-x(2,1)),abs(x(end,1)-x(end-1,1)));
    if x(1,1)>x(end,1)
        outfig(1).Parent.XAxis.TickValues=flipud(x(:,1));
        xlim([x(end,1)-mindiff,x(1,1)+mindiff]);
    else
        outfig(1).Parent.XAxis.TickValues=x(:,1);
        xlim([x(1,1)-mindiff,x(end,1)+mindiff]);
    end
    
    
%     set(outfig.Parent,'XTickLabel',x(:,1));

    %ylim([min(y) max(y)]);
    title(Title);
    
    
end

