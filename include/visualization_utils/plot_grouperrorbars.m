function [ outfig1,outfig2 ] = plot_errobars( x,y,yerr,xLabel,yLabel,Legend,Title)

    
hold on;
outfig1=bar(x,y ,'BarLayout','grouped');


if nargin>3
xlabel(xLabel);
ylabel(yLabel);
legend(Legend);
title(Title);
end
sizediff=size(y)-size(x);
if max(sizediff)>0
    x=repmat(x',max(sizediff)+1,1)';
end
if ~isempty(yerr)
    outfig2=errorbar(x',y',yerr' ,'.k','LineWidth',2);
else
    outfig2=outfig1;
end

oufi=gca;
if size(x,1)>1
    mindiff=min(abs(x(1,1)-x(2,1)),abs(x(end,1)-x(end-1,1)));
    if x(1,1)>x(end,1)
        oufi(1).XAxis.TickValues=flipud(x(:,1));
        xlim([x(end,1)-mindiff,x(1,1)+mindiff]);
    else
        oufi(1).XAxis.TickValues=x(:,1);
        xlim([x(1,1)-mindiff,x(end,1)+mindiff]);
    end
end
    

end

