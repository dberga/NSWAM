function [ axis_out ] = add_axis( axisvalues, axislabel,axis_in,axis_order,axislimits, axistype, axislocation, axisstep )

        if nargin < 2, axislabel=''; end
        if nargin < 3, axis_in=gca; end
        if nargin < 4, axis_order='normal'; end
        if nargin < 5, axislimits=[min(axisvalues), max(axisvalues)]; end
        if nargin < 6, axistype='xAxis'; end
        if nargin < 7, axislocation='bottom'; end
        if nargin < 8, axisstep=(axislimits(2)-axislimits(1))./(length(axisvalues)-1); end
        
        
        if iscell(axis_in)
                axis_in=axis_in{end};
        end
            
        switch axistype
            case 'xAxis' %abcissa
                ax2 = axes('Position',axis_in.Position+[0 0 0 0],'Color','none','YTick', [],'NextPlot', 'add'); 
                ax2.XAxisLocation = axislocation;
                %ax2.XDir = axis_order;
                %ax2.XLim = axislimits;
                %ax2.XTick = axislimits(1):axisstep:axislimits(2);
                %ax2.XTickLabel=axisvalues;
                %ax2.XAxis.TickValues=axisvalues;
                
                ax2.XAxis.Limits=axis_in.XAxis.Limits;
                ax2.XAxis.TickValues=axis_in.XAxis.TickValues;
                if strcmp(axis_order,'reverse')
                    ax2.XTickLabel=flipud(axisvalues);
                else
                    ax2.XTickLabel=axisvalues;
                end
                xlabel(axislabel);
                axis_out=ax2;

            case 'yAxis' %ordenada
                ay2 = axes('Position',axis_in.Position+[0 0 0 0],'Color','none','XTick', [],'NextPlot', 'add'); 
                %ay2.YAxisLocation = axislocation;    
                %ay2.YDir = axis_order;
                %ay2.YLim = axislimits;
                %ay2.YTick = axislimits(1):axisstep:axislimits(2);    
                %ay2.YTickLabel=axisvalues;   
                
                ay2.YAxis.Limits=axis_in.YAxis.Limits;
                ax2.YAxis.TickValues=axis_in.YAxis.TickValues;
                
                xlabel(axislabel);
                axis_out=ay2;
        end
        
        
end

