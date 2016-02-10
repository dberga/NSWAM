function [J_exc,W_inh]=get_Jithetajtheta_v0_3(scale,K,orient,Delta,wave, zli)


multires=wave.multires;
orient_interaction=zli.orient_interaction;

diam=2*Delta+1; % maximum diameter of the area of influence

J_exc=zeros(diam,diam,K);
W_inh=zeros(diam,diam,K);


% xx=repmat([(Delta:-1:1),(0:Delta)],2*Delta+1,1);
% yy=repmat([(Delta:-1:1),(0:Delta)]',1,2*Delta+1);
xx=repmat([(-Delta:1:Delta)],2*Delta+1,1);
yy=repmat([(-Delta:1:Delta)]',1,2*Delta+1);
% d=zeros(diam,diam);

factor_scale=(2^(scale-1));
% factor_scale=(2^(scale)); % Per anar un factor 2 mes enlla en el cas de ON i OFF per separat

d=sqrt(xx.*xx+yy.*yy)/factor_scale;
% d=(abs(xx)+abs(yy))/factor_scale; % Manhattan distance

% d=sqrt(xx.*xx+yy.*yy);
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
		
		Dtheta=send_in_the_right_interval_pi_2(theta-thetap);
		
		% 	dtheta(dtheta>pi/2)=dtheta(dtheta>pi/2)-pi;
		% 	dtheta(dtheta<-pi/2)=dtheta(dtheta<-pi/2)+pi;
		
		
% 		if(Dtheta>pi/2)
% 			Dtheta=Dtheta-pi;
% 		else
% 			if(Dtheta<-pi/2)
% 				Dtheta=Dtheta+pi;
% 			end
% 		end
		
		
		c=complex(xx,yy);
		angline=send_in_the_right_interval_pi_2(angle(c));
		theta1=send_in_the_right_interval_pi_2(theta-angline);
		theta2=send_in_the_right_interval_pi_2(thetap-angline);
		
		angle1=theta1;
		angle2=theta2;
		
		if abs(angle1)<=abs(angle2)
			theta1=angle1;theta2=angle2;
		else
			theta1=angle2;theta2=angle1;
		end
		
		% Hi ha diferencia entre Li i Machecler !!!!
		beta=2*abs(theta1)+2*sin(abs(theta1+theta2)); % Li
% 		beta=2*abs(theta1)+2*sin(abs(theta1)+abs(theta2)); % Machecler

		% J: Excitation
		
		% Z.Li 
 		ii=find( (d>0 & d<=10 & beta<pi/2.69) | ((d>0 & d<=10 & beta<pi/1.1) & abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9) );
		% Xavier
% 		ii=find( ((d>0 & d./cos(beta/4)<=10 & beta<pi/2.69) | (d>0 & d<=10 & beta<pi/1.1)) & abs(theta1)<pi/4 & abs(theta2)<pi/4 );
		M_exc_conv(ii)=0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-(d(ii).^2)/90);
		
		% W: Inhibition
		
		% Z.Li (corregit segons diu a la seva web)
		jj=find(~(d==0 | d./cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) ); 
		% Xavier
% 		jj=find(~(d==0 | d./cos(beta/4)>=10 | beta<pi/1.1 |	abs(Dtheta)>=pi/2 | abs(theta1)<pi/8) ); 

        % Hi ha diferencia entre Li i Machecler !!!!
		M_inh_conv(jj)=0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(abs(Dtheta)/(pi/4))^1.5); % Li
% 		M_inh_conv(jj)=0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp((abs(Dtheta)/(pi/4))^1.5); % Machecler
		
		
		J_exc(:,:,o)=M_exc_conv;
		W_inh(:,:,o)=M_inh_conv;
		
% 		if o==2 && orient~=4 && (strcmp(multires,'a_trous') || strcmp(multires,'a_trous_contrast') )
% 			[J_diag, W_diag]=get_Jithetajtheta_v0_3(scale,4,4,Delta,wave, zli);
% 			J_exc(:,:,o)=(J_exc(:,:,o)+J_diag(:,:,4))*1.0;
% 			W_inh(:,:,o)=(W_inh(:,:,o)+W_diag(:,:,4))*1.0;
% 		end

		pes_diag=0.5;

		if o==2 || (orient==2 && o~=2)
% 			J_exc(:,:,o)=(J_exc(:,:,o)+rot90(J_exc(:,:,o)))*0.5;
% 			W_inh(:,:,o)=(W_inh(:,:,o)+rot90(W_inh(:,:,o)))*0.5;
			J_exc(:,:,o)=(J_exc(:,:,o)+fliplr(J_exc(:,:,o)))*pes_diag;
			W_inh(:,:,o)=(W_inh(:,:,o)+fliplr(W_inh(:,:,o)))*pes_diag;
		end
		
		J_exc(Delta+1,Delta+1,o)=0;
		W_inh(Delta+1,Delta+1,o)=0;
		
		
		% 	J_exc(:,:,o)=~diag(diag(J_exc(:,:,o))).*J_exc(:,:,o);
		% 	W_inh(:,:,o)=~diag(diag(W_inh(:,:,o))).*W_inh(:,:,o);
		
	end
end

		if orient==2 && (strcmp(multires,'a_trous') || strcmp(multires,'a_trous_contrast') )
			for o=1:K
				if o~=2
% 					J_exc(:,:,o)=(J_exc(:,:,o)+rot90(J_exc(:,:,o)))*0.5;
% 					W_inh(:,:,o)=(W_inh(:,:,o)+rot90(W_inh(:,:,o)))*0.5;
					J_exc(:,:,o)=(J_exc(:,:,o)+fliplr(J_exc(:,:,o)))*pes_diag;
					W_inh(:,:,o)=(W_inh(:,:,o)+fliplr(W_inh(:,:,o)))*pes_diag;
				end
			end
		end



J_exc=J_exc/(factor_scale^2);
W_inh=W_inh/(factor_scale^2);
end

