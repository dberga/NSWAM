function weights=get_border_weights(a,b)
% created 22 6 2012
% compute the weights of the vectors used to complte the padding


if(a>0.001)
	alpha=(4*a-b)./(3*a);
	weights=[alpha  1-alpha];
else
	weights=[0 0];
end

end