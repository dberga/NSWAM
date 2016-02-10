function [psi]=Psi(Dtheta)


psi=cos(abs(Dtheta)).^6;

% psi(abs(Dtheta)>pi/6)=0;


% psi=cos(abs(Dtheta));

% psi(abs(Dtheta)>pi/6)=0;

% Z Li 1999, pag 192
% psi=exp(-abs(Dtheta)./(pi/8));

end