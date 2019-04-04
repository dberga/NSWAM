function [ h ] = setsizefig( sizefig )

    
    while get(gcf,'position') ~= sizefig
        set(gcf,'position',sizefig);
    end
end

