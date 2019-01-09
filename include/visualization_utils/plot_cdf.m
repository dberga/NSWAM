function [h1, h2] = plot_cdf(x)

hold on;


%% CDF
h1=cdfplot(x);
h1.LineWidth=2;

%% Normal CDF (approximation)
h2=plot_cdf_normal(x);

legend({'Empirical CDF','Normal CDF'});

hold off;

title('');
xlabel('');
ylabel('');

end