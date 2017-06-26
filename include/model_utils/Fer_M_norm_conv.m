function [M_norm_conv,inv_den]=Fer_M_norm_conv(n_scales,dist_type,scale_type,epsilon,bScaleDelta,mida_min)

M_norm_conv=cell(n_scales,1);
inv_den=cell(n_scales,1);




for i=1:n_scales
% 	radi=2^i;
% 	factor_scale=(2^(i-1));
    if bScaleDelta
        radi=ceil(scale2size(i+1-(log2(32)-log2(mida_min)),scale_type,epsilon));
    else
        radi=2;
    end
    factor_scale = radi/2;
% 	factor_scale=scale2size(i,scale_type,epsilon);
	
	
	M_norm_conv{i}=zeros(2*radi+1,2*radi+1);
	
	xx=repmat([(-radi:1:radi)],2*radi+1,1);
	yy=repmat([(-radi:1:radi)]',1,2*radi+1);
	
	d=Distance_XOP(xx/factor_scale,yy/factor_scale,dist_type);
	
	M_norm_conv{i}(d<=2)=1;
	inv_den{i}=1/sum(M_norm_conv{i}(:));
end

		

end