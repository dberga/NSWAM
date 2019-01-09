function varargout = plotshaded(x,y_hilo,color,varargin);

% x        x coordinates
% y_hi     upper limit of shaded region
% y_lo     lower "
%
% example
% x=[-10:.1:10];plotshaded(x,[sin(x.*1.1)+1;sin(x*.9)-1],'r');

if size(y_hilo,1)>size(y_hilo,2)
    y_hilo=y_hilo';
end;

shadedstripes=0;
stripes=0;


if numel(color)==3
    if strcmp(color(2:3),'--');
        stripes=1;
    end
end;

justoutlines=0;
if numel(color)==2
    if strcmp(color(2),'-');
        justoutlines=1;
    end
end;


if numel(varargin)>0
    if strcmp(varargin{1},'--');
        stripes=1;
    end;
    if strcmp(varargin{1},'-');
        shadedstripes=1;
    end;
end

c=color;
if isa(color,'char')
    
    color=strrep(color,'-','');
    % make colors nicer
    switch color
        case 'r'
            color=[1 0 0];
        case 'rr'
            color=[1 .3 .2];
        case 'g'
            color=[.2 .5 0];
        case 'gg'
            color=[.4 .9 .3];
        case 'b'
            color=[0 0 1];
        case 'bb'
            color=[.2 .3 1];
        case 'k'
            color=[0 0 0];
        case 'kk'
            color=[0.5 0.5 0.5];
        case 'kk'
            color=[0.5 0.5 0.5];
        case 'c'
            color=[0 .5 .5];
        case 'p'
            color=[1 .5 .3];
        case 'y'
            color=[.8 .6 .0];
        otherwise
            color=[0 0 1];
    end;
else
    assert(numel(color)==3, 'must be 3 element vector');
    color=color./max(color);
end;

%plot(x,y,'color',color); % plot median

if size(y_hilo,1)==1 % just plot
    if stripes
        plot(x,y_hilo,'k--','color',color);
    else
        
        plot(x,y_hilo,'-','color',color);
    end
else
    
    if size(y_hilo,1)==2
        %plot .25,.75 quartiles
        px=[x,fliplr(x)];
        py=[y_hilo(1,:), fliplr(y_hilo(2,:))];
        
        if stripes
            plot(px,py,'k--','color',color);
        elseif justoutlines
            plot(px,py,'k-','color',color);
        else
            patch(px,py,1,'FaceColor',color,'EdgeColor','none');
        end;
        
    end;
    
    if size(y_hilo,1)==3 % also draw mean
        %plot .25,.75 quartiles
        px=[x,fliplr(x)];
        py=[y_hilo(1,:), fliplr(y_hilo(3,:))];
        if stripes
            plot(px,py,'k--','color',color);
        elseif justoutlines
            plot(px,py,'k-','color',color);
        else
            patch(px,py,1,'FaceColor',color,'EdgeColor','none');
        end
        if shadedstripes
            plot(x,y_hilo(2,:),'--','color',color);
        else
            plot(x,y_hilo(2,:),'-','color',color);
        end
        
    end;
    
    alpha(.2); % make patch transparent
end;
