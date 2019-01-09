function [ h ] = plot_roc( tp,fp,colors_all )

if nargin < 3, %default colors
  
    co = [0 0 1;
      0 0.5 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
  
    for c=1:size(co,1)
        colors_all{c}=co(c,:);
    end
end

[tp,fp]=clean_roc(tp,fp);

%plot here
h=plot(fp, tp,'.-');

%set colors here
for c=1:length(h)
   h.Color(c,:)= colors_all{c};
end

end

