function [ h ] = plot_pdf( X )

mu=nanmean(X);
sigma=nanstd(X);
pd=makedist('Normal',mu,sigma);

x = min(X):mu/100:max(X);
pdf_normal = pdf(pd,x);
h=plot(x,pdf_normal,'LineWidth',2);


end

