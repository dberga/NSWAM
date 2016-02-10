function [J_exc,W_inh]=get_Jithetajtheta(K,orient,Delta,wave, zli)


multires=wave.multires;
orient_interaction=zli.orient_interaction;

diam=2*Delta+1; % maximum diameter of the area of influence

J_exc=zeros(diam,diam,K);
W_inh=zeros(diam,diam,K);


% xx=repmat([(Delta:-1:1),(0:Delta)],2*Delta+1,1);
% yy=repmat([(Delta:-1:1),(0:Delta)]',1,2*Delta+1);
xx=repmat([(-Delta:1:Delta)],2*Delta+1,1);
yy=repmat([(-Delta:1:Delta)]',1,2*Delta+1);
d=zeros(diam,diam);
% d=sqrt(xx.*xx+yy.*yy)./(2^(scale-1));

d=sqrt(xx.*xx+yy.*yy);
% d=sqrt(xx.*xx+yy.*yy)*0.5; % Xavier: per tal de "ajuntar" els pixels separats per un pixel entremig




theta=angle_orient(orient,multires);

for o=1:K
	
	
	M_exc_conv=zeros(size(d));
	M_inh_conv=zeros(size(d));
	
	if (o~=orient && orient_interaction==0)
		J_exc(:,:,o)=0;
		W_inh(:,:,o)=0;
	else
		
		thetap=angle_orient(o,multires);
		
		Dtheta=theta-thetap;
		
		% 	dtheta(dtheta>pi/2)=dtheta(dtheta>pi/2)-pi;
		% 	dtheta(dtheta<-pi/2)=dtheta(dtheta<-pi/2)+pi;
		
		
		if(Dtheta>pi/2)
			Dtheta=Dtheta-pi;
		else
			if(Dtheta<-pi/2)
				Dtheta=Dtheta+pi;
			end
		end
		
		
		c=complex(xx,yy);
		angline=angle(c);
		theta1=theta-angline;
		theta2=thetap-angline;
		
		angle1=send_in_the_right_interval(theta1);
		angle2=send_in_the_right_interval(theta2);
		
		if abs(angle1)<=abs(angle2)
			theta1=angle1;theta2=angle2;
		else
			theta1=angle2;theta2=angle1;
		end
		
		
		beta=2*abs(theta1)+2*sin(abs(theta1)+abs(theta2)); % Hi ha diferencia entre Li i Machecler !!!!
		
		% J: Excitation
		
		ii=find( (d>0 & d<=10 & beta<pi/2.69) | (d>0 & d<=10 & beta<pi/1.1) & abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9 );
		M_exc_conv(ii)=0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-d(ii).*d(ii)/90);
		
		% W: Inhibition
		
		% 	jj=find(~(d==0 | d>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) );
		jj=find(~(d==0 | d./cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) ); % Diferencia entre Li i Machecler
		M_inh_conv(jj)=0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(abs(Dtheta)/(pi/4))^1.5);
		
		
		J_exc(:,:,o)=M_exc_conv;
		W_inh(:,:,o)=M_inh_conv;
		
		if o==2 & orient~=4 & (strcmp(multires,'a_trous') | strcmp(multires,'a_trous_contrast') )
			[J_diag, W_diag]=get_Jithetajtheta(4,4,Delta,wave, zli);
			J_exc(:,:,o)=(J_exc(:,:,o)+J_diag(:,:,4))*1.0;
			W_inh(:,:,o)=(W_inh(:,:,o)+W_diag(:,:,4))*1.0;
		end
		
		
		
		J_exc(Delta+1,Delta+1,o)=0;
		W_inh(Delta+1,Delta+1,o)=0;
		
		
		% 	J_exc(:,:,o)=~diag(diag(J_exc(:,:,o))).*J_exc(:,:,o);
		% 	W_inh(:,:,o)=~diag(diag(W_inh(:,:,o))).*W_inh(:,:,o);
		
	end
end
	
end

