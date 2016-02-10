function [v]=send_in_the_right_interval(u)

v=u;

iii=find(abs(v)>pi);
v(iii)=2*pi-sign(v(iii)).*v(iii);

ii=find(abs(v)>pi/2);
v(ii)=v(ii)-sign(v(ii))*pi;

end   