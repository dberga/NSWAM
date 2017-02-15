function [ exponent ] = get_closer_2exp( n )
    exponent = 0;
    power = 0;
    while power < n
        power = 2^exponent;
        exponent = exponent+1;
    end
    exponent = exponent-1;
end

