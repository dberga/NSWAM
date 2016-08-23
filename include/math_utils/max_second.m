function [ y , idx] = max_second( x , first )

 [y, idx] = max(x(x<first));

end
