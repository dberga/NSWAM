function [v]=send_in_the_right_interval_pi_2(u)

v=u;

pi2=pi/2;

ii=abs(v)>pi;
% if ii
% 	v(ii)=v(ii)-pi;
	v(ii)=mod(v(ii),pi);
% end

iii=abs(v)>pi2;
% if iii
% 	v(iii)=pi-sign(v(iii)).*v(iii);
 	v(iii)=mod(v(iii)+pi2,pi)-pi2;
% end

end