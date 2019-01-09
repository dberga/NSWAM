function [ h ] = plot_cdf( X )


mu=nanmean(X);
sigma=nanstd(X);
pd=makedist('Normal',mu,sigma);

x = min(X):mu/100:max(X);
cdf_normal = cdf(pd,x);
cdf_rayleight = raylcdf(X,1);
h=plot(x,cdf_normal,'LineWidth',2);


end

