function [  ] = saveas2( fig, path )
    if ~exist(path,'file')
%         saveas(fig,path);
          print(fig, '-dpng', '-r0', path);
    end

end

