function h = plot_raster(x,y,width,color,linew)
% Simple XY plot with the symbol '|' instead of '.' or 'o'.
%
% Syntax:  
%     h = plot_raster(x,y,width,color,linew)
%
%       Where:  'x' and 'y' are data vectors
%               'width', 'color' and 'linew' are the width (standard=1), 
%                            color (standard='k' or [0 0 0]) and linewidth 
%                            (standard=1) of each '|' symbol.
%
% Examples:
%     1)     plot_raster( 5:10 ),    xlim([0 7])
%     2)     plot_raster( 5:10 , 0 ),   xlim([4 11]),   ylim([-2 2])
%     3)     plot_raster( 5:10 , 5:-1:0 ),   xlim([4 11])
%     4)     plot_raster( 5:10 , 5:-1:0 , 2),   xlim([4 11])
%     5)     plot_raster( 5:10 , 5:-1:0 , 2 , 'r'),   xlim([4 11])
%     6)     plot_raster( 5:10 , 5:-1:0 , 2 , [0.4 0.7 0] ),   xlim([4 11])
%     7)     plot_raster( 5:10 , 5:-1:0 , 2 , 'r', 2),   xlim([4 11])
%
%     8)     spk_ts{1}=[6.18;6.19;6.46;7.01;7.51;8.37;8.37;8.45;8.47;8.59;8.65;8.95;9.09;9.10;9.12;9.21;9.21;9.22;9.23;9.30;9.31;];
%            spk_ts{2}=[5.65;5.87;6.36;6.37;6.49;6.63;6.74;6.86;6.86;6.99;6.99;7.13;7.36;7.45;7.56;8.34;8.35;8.61;8.6;];
%            spk_ts{3}=[3.78;5.37;6.97;7.06;7.07;7.08;7.23;7.43;7.44;7.45;7.67;7.72;7.76;7.77;7.78;7.89;];
%            spk_ts{4}=[6.18;6.19;6.46;7.01;7.51;8.37;8.37;8.45;8.47;8.59;8.65;8.95;9.09;9.10;9.12;9.21;9.21;9.22;9.23;9.30;9.31;];
%            spk_ts{5}=[5.65;5.87;6.36;6.37;6.49;6.63;6.74;6.86;6.86;6.99;6.99;7.13;7.36;7.45;7.56;8.34;8.35;8.61;8.6;];
%            spk_ts{6}=[3.78;5.37;6.97;7.06;7.07;7.08;7.23;7.43;7.44;7.45;7.67;7.72;7.76;7.77;7.78;7.89;];
%            for t=1:6
%                trial{t}=t*ones(size(spk_ts{t}));
%            end
%            plot_raster( cell2mat(spk_ts(:)) ,  cell2mat(trial(:))  )
%            axis tight
%            xlim([0 12])
%            box off
%            xlabel('Time (s)')
%            ylabel('Trial #')
%
% Doubts: rpavao@gmail.com

if nargin<1; help plot_raster; return; end
if nargin<2 || isempty(y); y=x; x=1:length(y); end
if nargin<3 || isempty(width); width=1; end
if nargin<4 || isempty(color); color='k'; end
if nargin<5 || isempty(linew); linew=1; end

if length(x)==1 && length(y)>1
    x=ones(size(y))*x;
end
if length(y)==1 && length(x)>1
    y=ones(size(x))*y;
end

plot([x(:)'; x(:)'], [y(:)'+width/2; y(:)'-width/2],'-','color',color,'linewidth',linew)
