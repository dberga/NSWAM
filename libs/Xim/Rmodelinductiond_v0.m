function [gx_final,gy_final,inh_energy] = Rmodelinductiond_v0(im,struct)

%-------------------------------------------------------

% scale=wav.scale;
% orient=wav.orient;

wave=struct.wave;

n_scales=wave.n_scales;

% make the structure explicit
zli=struct.zli;
% compute=struct.compute;

% struct.zli
% differential equation
n_membr=zli.n_frame;
n_iter=zli.n_iter;
% prec=zli.prec;
% normalization
% zli.normal_input=4;
% zli.normal_output=2.0;
% 
% 
% zli.ON_OFF=0; % 0: separate, 1: abs, 2:square
% zli.nu_0=2;

% Delta
Delta=zli.Delta;

% normalization (I_norm)
r=zli.normalization_power;

boundary=zli.boundary;

kappa1=zli.kappa1(scale);
kappa2=zli.kappa2(scale); 


de=zli.dedi(1,scale);
di=zli.dedi(2,scale);

% struct.compute
% dynamic/constant
% dynamic=compute.dynamic;


%-------------------------------------------------------

% modif 
% sigma1=1./sqrt(pi.*de);
% sigma2=1./sqrt(pi.*di);
% sigma1=1;
% sigma2=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Input data normalization %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

im=curv_normalization(im);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alphax=zli.alphax;
alphay=zli.alphay;

% the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
% K=1; % no orientation here
K=size(im,4); % no orientation here

% self-excitation coefficient
J0=0.8;

%Difftheta=[[12;(1:11)'],[(2:12)';1],[11;12;(1:10)'],[(3:12)';1;2]];
% grid dimensions and number of preferred orientation in the hypercolumn
M=size(im,1);
N=size(im,2);

if N <= 10
   disp('bad stimulus dimensions, the toroidal boundary conditions are ill-defined')
end

% the membrane potentials
%x=zeros(M,N,K);
%y=zeros(M,N,K);
%Iitheta=zeros(M,N,K);
% if dynamic~=1 % stable: only each multiple
%     gx_final=zeros(M,N,K,niter);
%     gy_final=zeros(M,N,K,niter);
% else  % dynamic: store all
    gx_final=zeros(M,N,K,niter); % changed, was gx_final=zeros(M,N,K,niter/prec);
    gy_final=zeros(M,N,K,niter); % changed, was gy_... %
% end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% prepare the excitatory and inhibitory masks %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare the coefficient of the excitatory and inhibitory contributions
% the masks are given by 3Mx3NxK matrices (like for Itheta)

%M_exc=zeros(1,3*N,K);
%M_inh=zeros(1,3*N,K);

% for a two dimensional stimulus
% Delta=15; % maximum radius of the area of influence
%Delta=sqrt(max(de,di))*3;

diam=2*Delta+1; % maximum diameter of the area of influence

xx=repmat((Delta:-1:-Delta),2*Delta+1,1);
yy=repmat((Delta:-1:-Delta)',1,2*Delta+1);

d=zeros(diam,diam);
d=sqrt(xx.*xx+yy.*yy);



% d=repmat([(Delta:-1:1),(0:Delta)],2*Delta+1,1);
% d=d+d';

% 1-d to 2-d modification
% kappa=0.6706/4.4096;   % commented 29/11/11 (all in genpar.str)
% verify we heritate a code which is coherent with v3
ver=0;


% M_exc_conv=sigma1.*kappa1*0.126.*exp(-d.^2/de);
% if ver
%     verify=zeros(size(M_exc_conv));
%     verify((size(M_exc_conv,1)+1)/2,:)=M_exc_conv((size(M_exc_conv,1)+1)/2,:)./kappa; % maximum radius of the area of influence
%     M_exc_conv=verify;
% end
% M_inh_conv=sigma2.*kappa2*0.126.*exp(-d.^2/di);
% if ver
%     verify=zeros(size(M_inh_conv));
%     verify((size(M_exc_conv,1)+1)/2,:)=M_inh_conv((size(M_exc_conv,1)+1)/2,:)./kappa;
%     M_inh_conv=verify;
% end    





% M_exc_conv=kappa1*0.126.*exp(-d.^2/de);
% M_inh_conv=kappa2*0.126.*exp(-d.^2/di);
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Normalization mask %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M_normalization=zeros(1,3*N,K);

% one dimensional normalization mask
M_normalization_base=[zeros(1,8),ones(1,5),zeros(1,17)];
M_normalization(1,1:30)=M_normalization_base;
M_normalization=circshift(M_normalization,[0 N+1-11]);

% two_dimensional
M_norm_conv=ones(5,5);
den=25;
inv_den=1/25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% the input image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Iitheta=im(:,:,:,:,1);
toroidal_Itheta=padarray(Iitheta,[Delta,Delta,0,0],'symmetric');  % for the toroidal boundary condition

% nothing to do here
% Iitheta=im;
% in this version, there is sth to do: we only have as many image as nb of
% membrane time constant so we have to expand the stimulus to a niter/prec
% B=zeros(M,N,1,niter);B(:,:,1,:)=im;
% C=repmat(B,[1,1,1/prec,1]);
% Iitheta=reshape(C,M,N,[]);
% toroidal boundary condition
%   toroidal_Iitheta=repmat(Iitheta,3,3);
 
% mirrored boundary
% if dynamic~=1
%         toroidal_Iitheta=[fliplr(im),im,fliplr(im)];
%         toroidal_Iitheta=repmat(toroidal_Iitheta,3,1);   % WARNING !!! that's not a real mirror in the vertical
%                                                          % dimensino here; should
%                                                          % be modified
%                                                          % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%         newgx_toroidal_Iitheta=newgx(toroidal_Iitheta);
% elseif dynamic==1
%         % loop? another idea? yes, resize...
%         [xa,yb,zc]=size(im);
%         zc=1;  % I think it's sufficient (only the first frame should be taken into consideration here!)
%         % toroidal_Iitheta=zeros(xa,yb,zc);
%         for iii=1:zc
%             toroidal_Iitheta(:,:,iii)=repmat([fliplr(im(:,:,iii)),im(:,:,iii),fliplr(im(:,:,iii))],3,1);
%         end    
%         newgx_toroidal_Iitheta=newgx(toroidal_Iitheta(:,:,1)); % no change for the first frame
% end        



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% prepare orientation/scale interaction for x_ei   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orientations
switch(wave.multires)
	case('wav')
		a=0.7854;
		b=1.5708;
		Dtheta=[0 a b; a 0 a ; b a 0];
		PsiDtheta=Psi(Dtheta);
	case('gabor_HMAX')
		Dtheta=zeros(K,K);
		theta=angle_orient(1,wave.multires);
		Dtheta(1,:)=theta-angle_orient([1:K],wave.multires);
		for o=2:K
			Dtheta(o,:)=circshift(Dtheta(1,:),[1,o-1]);
		end
		PsiDtheta=Psi(Dtheta);
end
% scales (define the interraction between the scales)
radius_sc=1;
weight_scales=zeros(1,1+2*radius_sc);
weight_scales=[0.3 1 0.3];
% define the filter
scale_filter=zeros(1,1,1+2*radius_sc,1);
scale_filter(1,1,:,1)=weight_scales;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%        prepare J_ithetajtheta' and J_ithetajtheta       %%%%%%%%%%%%
%%%%%             for x_ee    and y_ie								%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_J=zeros(diam,diam,K,K);
all_W=zeros(diam,diam,K,K);
for o=1:K
	[all_J(:,:,:,o),all_W(:,:,:,o)]=get_Jithetajtheta(M,N,K,o,Delta,wave.multires);
end	
J=zeros(diam,diam,1,K,K);
W=zeros(diam,diam,1,K,K);

J(:,:,1,:,:)=all_J;all_J=J;
W(:,:,1,:,:)=all_W;all_W=W;



% scales (cf. above )

if radius_sc >0
	J=zeros(diam,diam,n_scales,K,K);
	W=zeros(diam,diam,n_scales,K,K);
	for ii=1:length(weight_scales)
		J(:,:,ii,:,:)=weight_scales(ii).*all_J(:,:,1,:,:);
		W(:,:,ii,:,:)=weight_scales(ii).*all_W(:,:,1,:,:);
	end
	all_J=J;
	all_W=W;
end

% thetap=angle_orient(orient,wave.multires);
% 
% c=complex(xx,yy);
% angline=angle(c);
% theta1=theta-angline;
% theta2=thetap-angline;
% 
% 
% beta=2*abs(theta1)+2*sin(abs(theta1+theta2)); % Hi ha diferencia entre Li i Machecler !!!!
% 
% % J: Excitation
% 
% ii=find((d>0 & d<=10 & beta<pi/2.69) | (d>0 & d<=10 & beta<pi/1.1) & (abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9 ));
% M_exc_conv(ii)=kappa1*0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-d(ii).*d(ii)/90);
% 
% % W: Inhibition
% 
% jj=find(~(d==0 | d>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) );
% % jj=find(~(d==0 | d/cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) ); % Diferencia entre Li i Machecler
% M_inh_conv(jj)=kappa2*0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(Dtheta/(pi/4))^1.5);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Nadal's diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

if nargout==3
   inh_energy=zeros(K,niter);
end   

ones_M_N=ones(M,N);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% the loop over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=size(im{t_m},4);

% preallocate
x=zeros(M,N,n_scales,K);
x=Iitheta; % visual input Iitheta initializes the activity levels newgx(x) (p.192)
y=zeros(M,N,n_scales,K);


for t_membr=1:n_membr  % membrane time
	

	% mirror boundary condition
	toroidal_x=padarray(x,[Delta,Delta,0,0],'symmetric');
	toroidal_y=padarray(y,[Delta,Delta,0,0],'symmetric');
				
	
	for t_iter=1:n_iter  % from the differential equation (Euler!)
		
		newgx_toroidal_x=newgx(toroidal_x);
		newgy_toroidal_y=newgy(toroidal_y);
		% temporary variables
		%x_int=zeros(M,N,n_scales,K);
		%y_int=zeros(M,N,n_scales,K);
		x_ee=zeros(M,N,n_scales,K);
		x_ei=zeros(M,N,n_scales,K);
		y_ie=zeros(M,N,n_scales,K);
		I_norm=zeros(M,N,n_scales,K);
		
	
		%%%%%%%%%%%%%% preparation terms %%%%%%%%%%%%%%%%%%%%%%%%%%
		for oc=1:K  % loop over the central (reference) orientation
			
			
			
			% excitatory-inhibitory term (no existia):   x_ei
			% influence of the neighboring scales first
			sum_scale_newgy_toroidal_y=convolucio_optima(newgy_toroidal_y,scale_filter); % does it give the right dimension? 'same' needed?
			w=zeros(1,1,1,K);w(1,1,1,:)=PsiDtheta(oc,:);
			
			x_ei(:,:,:,oc)=sum(sum_scale_newgy_toroidal_y.*repmat(w,[M,N,n_scales,1]),4);
			
			% convolucio amb una "barreta" de dimensio 1 donada per Psi
			% 				x_ei=convolucio_optima(newgy(y_int)(x,y,:),Psi(Dtheta));
			% proves:  newgy_y_int=rand(20,20,n_scales,3);
			
			
			
			
			
			% excitatory and inhibitory terms (the big sums)
			% excitatory-excitatory term:    x_ee
			% excitatory-inhibitory term:    y_ie
			for ov=1:K  % loop over all the orientations given the central (reference orientation)
				
				
				
				
				% 					[all_J(:,:,:,o),all_W(:,:,:,o)]=get_Jithetajtheta(M,N,K,o,Delta,wave.multires);
				
				J_ov=all_J(:,:,:,ov,oc);
				W_ov=all_W(:,:,:,ov,oc);
				
				%J_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),J_ov);
				%W_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),W_ov);
				
				
				J_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam),:,ov),J_ov);
				W_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam),:,ov),W_ov);
				
				
			end
			
			x_ee(:,:,:,oc)=sum(J_conv_tmp,4);
			y_ie(:,:,:,oc)=sum(W_conv_tmp,4);
			
			
			
			
		end   % of the loop over the central (reference) orientation
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		%%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% we generalize Z.Li's formula for the normalization by suming
		% over all the scales within a given hypercolumn (cf. p209, where she
		% already sums over all the orientations) 
		sum_newgx_toroidal_x=sum(sum(newgx_toroidal_x,3),4);
		kk=convolucio_optima(sum_newgx_toroidal_x,M_norm_conv);
		I_norm_base=kk(M+1:2*M,N+1:2*N);
		I_norm_base=-2*(I_norm_base*inv_den).^r;
		
		for s=n_scales  % use repmat instead !!!!
			for o=1:K
				I_norm(:,:,s,o)=I_norm_base;
			end
		end
		%%%%%%%%%%%%%% end normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		
		
		
		%%%%%%%%% CENTRAL FORMULA (formulae (1) and (2) p.192) %%%%%%
% 		if t_iter==1  % first iteration of each (Euler) differential equation
% 			% (1) excitatory neurons
% 			x=x+prec*(-alphax*x...				% decay
% 				-newgy(y)-...						% ei term % verifica en aquest cas!
% 				+J0*newgx(Iitheta(:,:,:,:,t_membr))... % input
% 				+x_ee...						% ee of the first step of the equation
% 				+I_norm...				% normalization
% 				+0.85);             % spontaneous firing rate?
% 			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for speed)
% 			
% 			
% 			
% 			
% 			% (2) inhibitory neurons
% 			y=y+prec*(-alphay*y....
% 				+newgx(Iitheta(:,:,:,:,t_membr))...
% 				+1);
% 			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for speed)
% 			
% 		else
			% (1) excitatory neurons
			x=x+prec*(-alphax*x...				% decay
				-newgy(y)...
				-x_ei...						% ei term
				+J0*newgx(x)... % input
				+x_ee...
				+Iitheta(:,:,:,:,t_membr)... % Iitheta: should be deinfed!!!!
				+I_norm...				% normalization
				+0.85);             % spontaneous firing rate?
			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for speed)
			
			% (2) inhibitory neurons
			y=y+prec*(-alphay*y...     % decay
				+newgx(x)...
				+y_ie...
				+1);     % spontaneous firing rate?
			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for
			%speed)
%		end
				
		
		disp('questions: verify that the newgy(y) newgx(x) are not in the expressions y_ei,x_ei,x_ee ')
	end % end t_iter=1:n_iter	

	%if t*prec==ceil(t*prec) % added 1/2/12
		gx_final(:,:,:,t_membr)=newgx(x); % was gx_final(:,:,:,t)=newgx(x(:,:,:));
		gy_final(:,:,:,t_membr)=newgy(y);

end  % end t_membr=1:t_membr
	

end

% 	WAS
% 	
% 	if t==1
% 					                       y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(Iitheta(:,:,k))+...
% 					                                         y_int(:,:,k)+...
% 					                                         ones_M_N+...
% 					                                         0.1*(rand(M,N)-0.5));
% 					                    else
% 					                       y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
% 					                                         y_int(:,:,k)+...
% 					                                         ones_M_N+...
% 					                                         0.1*(rand(M,N)-0.
% 					                                         5));
% 				
% 				
% 
% 			
% 		WAS	
% 			else
% 						x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
% 							J0*newgx(x(:,:,k))+...
% 							x_int(:,:,k)+...
% 							Iitheta(:,:,t)+...                                     % the image
% 							0.85*ones_M_N+...
% 							I_norm(:,:,k));%+...
% 						%                                         0.1*(rand(M,N)-0.5));
% 						% energy of inhibition
% 						if nargout==3
% 							inh_energy(k,t)=sum(sum((Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
% 								newgy(y(:,:,Difftheta(k,2))))-...
% 								Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
% 								newgy(y(:,:,Difftheta(k,4))))).^2));
% 						end
% 			
% 			
% 		end	
% 		
% 		
% 		
% 				
% 				
% 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 				%%%%%%%%%% excitation-inhibition %%%%%%%%%%%%%%%%%%
% 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 				
% 				
% 				for k=1:K
% 					if t==1
% 						kk=convolucio_optima(newgx_toroidal_Iitheta(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_exc_conv);
% 						x_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
% 						kk=convolucio_optima(newgx_toroidal_Iitheta(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_inh_conv);
% 						y_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
% 					else
% 						kk=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_exc_conv);
% 						x_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
% 						kk=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_inh_conv);
% 						y_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
% 					end
% 					
% 					kk=convolucio_optima(newgx_toroidal_x,M_norm_conv);
% 					
% 					I_norm(:,:,k)=kk(M+1:2*M,N+1:2*N);
% 					I_norm(:,:,k)=-2*(I_norm(:,:,k).*inv_den).^r;
% 					
% 					
					
					
					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
					%%%%%%%%%%% normalization process %%%%%%
					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
					
					%       if dynamic~=1 % ----------------- fixed input image -------------------
					%                   % Iteration step (t -> t+1)
					%                     if t==1
					%                        x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
					%                                          J0*newgx(Iitheta(:,:,k))+...
					%                                          x_int(:,:,k)+...
					%                                          Iitheta(:,:,k)+...                                     % the image
					%                                          0.85*ones_M_N+...
					%                                          I_norm(:,:,k)+...
					%                                          0.1*(rand(M,N)-0.5));
					%                        % energy of inhibition
					%                        if nargout==3
					%                           inh_energy(k,t)=sum(sum((newgy(y(:,:,k))+Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
					%                                          newgy(y(:,:,Difftheta(k,2))))+...
					%                                          Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
					%                                          newgy(y(:,:,Difftheta(k,4))))).^2));
					%                        end
					%
					%                    else
					%                         x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
					%                                          J0*newgx(x(:,:,k))+...
					%                                          x_int(:,:,k)+...
					%                                          Iitheta(:,:,k)+...                                     % the image
					%                                          0.85*ones_M_N+...
					%                                          I_norm(:,:,k)+...
					%                                          0.1*(rand(M,N)-0.5));
					%                        % energy of inhibition
					%                        if nargout==3
					%                           inh_energy(k,t)=sum(sum((Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
					%                                          newgy(y(:,:,Difftheta(k,2))))-...
					%                                          Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
					%                                          newgy(y(:,:,Difftheta(k,4))))).^2));
					%                        end
					%                     end
					%
					%
					%                     if t==1
					%                        y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(Iitheta(:,:,k))+...
					%                                          y_int(:,:,k)+...
					%                                          ones_M_N+...
					%                                          0.1*(rand(M,N)-0.5));
					%                     else
					%                        y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
					%                                          y_int(:,:,k)+...
					%                                          ones_M_N+...
					%                                          0.1*(rand(M,N)-0.5));
					%                     end
					%       elseif dynamic==1  % ----------------- dynamic input image -------------------
					% here Iitheta chnages with time
					% Iteration step (t -> t+1)
% 					if t==1
% 						x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
% 							J0*newgx(Iitheta(:,:,k,t))+...
% 							x_int(:,:,k)+...
% 							Iitheta(:,:,k,t)+...                                     % the image
% 							0.85*ones_M_N+...
% 							I_norm(:,:,k)); %+...
% 						%                                         0.1*(rand(M,N)-0.5));
% 						% energy of inhibition
% 						if nargout==3
% 							inh_energy(k,t)=sum(sum((newgy(y(:,:,k))+Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
% 								newgy(y(:,:,Difftheta(k,2))))+...
% 								Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
% 								newgy(y(:,:,Difftheta(k,4))))).^2));
% 						end
% 						
% 					else
% 						x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
% 							J0*newgx(x(:,:,k))+...
% 							x_int(:,:,k)+...
% 							Iitheta(:,:,t)+...                                     % the image
% 							0.85*ones_M_N+...
% 							I_norm(:,:,k));%+...
% 						%                                         0.1*(rand(M,N)-0.5));
% 						% energy of inhibition
% 						if nargout==3
% 							inh_energy(k,t)=sum(sum((Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
% 								newgy(y(:,:,Difftheta(k,2))))-...
% 								Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
% 								newgy(y(:,:,Difftheta(k,4))))).^2));
% 						end
% 					end
% 					
% 					
% 					if t==1
% 						y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(Iitheta(:,:,t))+...
% 							y_int(:,:,k)+...
% 							ones_M_N);%+...
% 						%                                         0.1*(rand(M,N)-0.5));
% 					else
% 						y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
% 							y_int(:,:,k)+...
% 							ones_M_N);%+...
% 						%                                         0.1*(rand(M,N)-0.5));
% 					end
% 					%       end % of the dynamic/constant structure ---------------------------------------
% 					
% 				end
% 				
% 			% end
% 		end
% 	end
	% if dynamic~=1
	%         % Non-dynamic case: store the values at any multiples of the membrane time constant
	%         if t*prec==ceil(t*prec)
	%               gx_final(:,:,:,t*prec)=newgx(x(:,:,:));
	%               gy_final(:,:,:,t*prec)=newgy(y(:,:,:));
	%         end
	% else
	% Dynamic case: store the values at any membrane time constant
    

