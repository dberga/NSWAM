function [gx_final] = Rmodelinductiond_v0_1(Iitheta,struct)

%-------------------------------------------------------

% scale=wav.scale;
% orient=wav.orient;

wave=struct.wave;

use_fft=struct.compute.use_fft;

n_scales=wave.n_scales;

% make the structure explicit
zli=struct.zli;
% compute=struct.compute;

% struct.zli
% differential equation
n_membr=zli.n_membr;
n_iter=zli.n_iter;
prec=1/n_iter;
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

% boundary=zli.boundary;




% kappa1=zli.kappa1(scale);
% kappa2=zli.kappa2(scale); 
% 
% de=zli.dedi(1,scale);
% di=zli.dedi(2,scale);




% struct.compute
% dynamic/constant
% dynamic=compute.dynamic;

XOP_DEBUG=struct.compute.XOP_DEBUG;

%-------------------------------------------------------

% modif 
% sigma1=1./sqrt(pi.*de);
% sigma2=1./sqrt(pi.*di);
% sigma1=1;
% sigma2=1;


M=size(Iitheta{1},1);
N=size(Iitheta{1},2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Input data normalization %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	
if XOP_DEBUG
	for i=1:n_membr
% 		Iitheta{i}=Iitheta{i}*0;

		
% 		for ii=N/2:N/2
% 			for jj=1:M
% 				Iitheta{i}(jj,ii,1,1)=1;
% 			end
% 		end

% 		for ii=-10:10
% 			for jj=-10:10
% 				Iitheta{i}(floor(M/2)+ii,floor(N/2)+jj,1,1)=1;
% 			end
% 		end
		
		
% 		for ii=1:2:N
% 			for jj=1:2:M
% 				Iitheta{i}(jj,ii,:,:)=1;
% 			end
% 		end
	
	
	end
end




[Iitheta,normal_max,normal_min]=curv_normalization(Iitheta,struct);

% if struct.display_plot.store==1
% 	save('Iitheta','Iitheta');
% end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alphax=zli.alphax;
alphay=zli.alphay;

% the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
% K=1; % no orientation here
K=size(Iitheta{1},4); % no orientation here

% self-excitation coefficient
J0=0.8;

%Difftheta=[[12;(1:11)'],[(2:12)';1],[11;12;(1:10)'],[(3:12)';1;2]];
% grid dimensions and number of preferred orientation in the hypercolumn
% M=size(Iitheta{1},1);
% N=size(Iitheta{1},2);

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

gx_final=cell(n_membr,1);
gy_final=cell(n_membr,1);
% iFactor=gx_final;

for i=1:n_membr
    gx_final{i}=zeros(M,N,n_scales,K); % changed, was gx_final=zeros(M,N,K,niter/prec);
    gy_final{i}=zeros(M,N,n_scales,K); % changed, was gy_... %
% 	 iFactor{i}=gx_final;
end
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



% 1-d to 2-d modification
% kappa=0.6706/4.4096;   % commented 29/11/11 (all in genpar.str)
% verify we heritate a code which is coherent with v3
ver=0;


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


% toroidal_Itheta_0=padarray(Iitheta{1},[Delta,Delta,0,0],'symmetric');  % for the toroidal boundary condition




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% prepare orientation/scale interaction for x_ei   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orientations
switch(wave.multires)
	case('wav')
		a=pi/4;
		b=pi/2;
		Dtheta=[0 a b; a 0 a ; b a 0];
		PsiDtheta=Psi(Dtheta);
	case('a_trous')
		a=pi/4;
		b=pi/2;
		Dtheta=[0 a b; a 0 a ; b a 0];
		PsiDtheta=Psi(Dtheta);
	case('a_trous_contrast')
		a=pi/4;
		b=pi/2;
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
n_weight_scales=length(weight_scales);

if(zli.scale_interaction==1)
	e=0.1;
	f=1;
else
	e=0;
	f=1;
end

weight_scales=[e f e];
border_weight=get_border_weights(e,f);

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
	[all_J(:,:,:,o),all_W(:,:,:,o)]=get_Jithetajtheta(K,o,Delta,wave,zli);
end	
J=zeros(diam,diam,1,K,K);
W=zeros(diam,diam,1,K,K);

J(:,:,1,:,:)=all_J;all_J=J;
W(:,:,1,:,:)=all_W;all_W=W;



% scales (cf. above )

if radius_sc >0
	J=zeros(diam,diam,n_weight_scales,K,K);
	W=zeros(diam,diam,n_weight_scales,K,K);
	for ii=1:n_weight_scales
		J(:,:,ii,:,:)=weight_scales(ii).*all_J(:,:,1,:,:);
		W(:,:,ii,:,:)=weight_scales(ii).*all_W(:,:,1,:,:);
	end
	all_J=J;
	all_W=W;
end


	% A Matrix for each scale




% FFT

if (use_fft)
	
	all_J_fft=zeros(M+2*Delta,N+2*Delta,n_scales+2*radius_sc,K,K);
	all_W_fft=zeros(M+2*Delta,N+2*Delta,n_scales+2*radius_sc,K,K);
	
	for ov=1:K
		for oc=1:K
			all_J_fft(:,:,:,ov,oc)=fftn(all_J(:,:,:,ov,oc),[M+2*Delta,N+2*Delta,n_scales+2*radius_sc]);
			all_W_fft(:,:,:,ov,oc)=fftn(all_W(:,:,:,ov,oc),[M+2*Delta,N+2*Delta,n_scales+2*radius_sc]);
		if XOP_DEBUG
% 			all_W_fft(:,:,:,ov,oc)=all_W_fft(:,:,:,ov,oc)*0; % Xavier: desactivem inhibicio
		end
		end
	end
	half_size_filter=[Delta Delta radius_sc];
% 	half_size_filter=[Delta Delta 0];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Nadal's diagnostics
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

if nargout==3
   inh_energy=zeros(K,niter);
end   

% ones_M_N=ones(M,N);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% the loop over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=size(Iitheta{1},4);

% preallocate
x=Iitheta{1}; % visual input (Iitheta) initializes the activity levels newgx(x) (p.192)
y=zeros(M,N,n_scales,K);
% preallocate for speed
J_conv_tmp=zeros(M+2*Delta,N+2*Delta,n_scales+2*radius_sc,K);
W_conv_tmp=zeros(M+2*Delta,N+2*Delta,n_scales+2*radius_sc,K);

if XOP_DEBUG
% 	scrsz = get(0,'ScreenSize');
% 	figure('Name','x','Position',[1 scrsz(4) N M]);title('x');fig_x=gcf;kk=get(fig_x,'Position');f_ampl=kk(3);f_alc=kk(4);
% 	figure('Name','y','Position',[1+f_ampl scrsz-f_alc N M]);title('y');fig_y=gcf;
% 	figure('Name','newgx');title('newgx');fig_newgx=gcf;
% 	figure('Name','newgy');title('newgy');fig_newgy=gcf;
% 	figure('Name','I_norm');title('I_norm');fig_I_norm=gcf;
			for s=1:2
				for o=1:3
					fig(s,o)=figure('Name',['s: ' int2str(s) ', o: ' int2str(o)]);
					pos=get(fig(s,o),'OuterPosition');
					set(fig(s,o),'OuterPosition',[0+(o-1)*pos(3) 0+(s-1)*pos(4) pos(3) pos(4)]);
				end
			end
%     subplot(2,3,1);title('x');
%     subplot(2,3,2);title('y');
%     subplot(2,3,3);title('I_norm');
%     subplot(2,3,4);title('newg_x');
%     subplot(2,3,5);title('newg_y');
end
		
for t_membr=1:n_membr  % membrane time
	
	disp(['t_membr: ' int2str(t_membr)]);

		tic

		for t_iter=1:n_iter  % from the differential equation (Euler!)

% 		if XOP_DEBUG
% 			show_x_y(fig,x,y,I_norm);
% 		end
	

% 		if XOP_DEBUG
% 			imagesc(x(:,:,1,1));colormap('gray');
% 		end
		
		% mirror boundary condition
		toroidal_x=padarray(x,[Delta,Delta,0,0],'symmetric');
		toroidal_y=padarray(y,[Delta,Delta,0,0],'symmetric');
		
		toroidal_x=padarray(toroidal_x,[0,0,radius_sc,0],0);
		toroidal_y=padarray(toroidal_y,[0,0,radius_sc,0],0);
		
		% Assignar valors al pad de les escales
		
		% 	toroidal_x(:,:,1:1+radius_sc,:)=border_weight(1).*toroidal_x(:,:,1+radius_sc,:)+...
		% 		border_weight(2).*toroidal_x(:,:,1+radius_sc+1,:)
		
		kk_tmp1=zeros(size(toroidal_x(:,:,1,:))); % El dia que ho generalitzem haura de ser 1:radius_sc
		kk_tmp2=kk_tmp1;
		
		for i=1:radius_sc+1
			kk_tmp1=kk_tmp1+border_weight(i)*toroidal_x(:,:,radius_sc+i,:);
			kk_tmp2=kk_tmp2+border_weight(i)*toroidal_x(:,:,n_scales+i-1,:);
		end
		
		
		toroidal_x(:,:,1:radius_sc,:)=kk_tmp1;
		toroidal_x(:,:,n_scales+radius_sc+1:n_scales+2*radius_sc,:)=kk_tmp2; % ??????????????????????
	
		
	disp(['t_iter: ' int2str(t_iter)]);
		
		
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
			sum_scale_newgy_toroidal_y=convolucio_optima(newgy_toroidal_y,scale_filter,0,0); % does it give the right dimension? 'same' needed?
			restr_sum_scale_newgy_toroidal_y=sum_scale_newgy_toroidal_y(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales,:);
			w=zeros(1,1,1,K);w(1,1,1,:)=PsiDtheta(oc,:);
			
			x_ei(:,:,:,oc)=sum(restr_sum_scale_newgy_toroidal_y.*repmat(w,[M,N,n_scales,1]),4);
			
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
				if XOP_DEBUG
% 					W_ov=all_W(:,:,:,ov,oc)*0; %Xavier: Desactivem inhibicio
				end
				
				%J_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),J_ov);
				%W_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),W_ov);
				
				
				% FFT
				if (use_fft)
					J_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),all_J_fft(:,:,:,ov,oc),half_size_filter,1);  % (max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)
					restr_J_conv_tmp=J_conv_tmp(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales,:);
					
					% Per debugar i comparar la FFT amb la convn
%  					kk_conv=convolucio_optima(newgx_toroidal_x(:,:,:,ov),J_ov,0,0);  
% 					restr_kk_conv=kk_conv(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales);
%  					dif=restr_J_conv_tmp(:,:,:,ov)-restr_kk_conv;
% 					sc=2;
% 					figure;imagesc(restr_J_conv_tmp(:,:,sc,ov));colormap('gray');
% 					figure;imagesc(restr_kk_conv(:,:,sc));colormap('gray');
% 					figure;imagesc(dif(:,:,sc));colormap('gray');
					% ========

					W_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),all_W_fft(:,:,:,ov,oc),half_size_filter,1);
					restr_W_conv_tmp=W_conv_tmp(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales,:);
				else
					J_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),J_ov,0,0);  % (max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)
					restr_J_conv_tmp=J_conv_tmp(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales,:);
					W_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),W_ov,0,0);
					restr_W_conv_tmp=W_conv_tmp(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales,:);
				end
				
			end
			
			x_ee(:,:,:,oc)=sum(restr_J_conv_tmp,4);
			y_ie(:,:,:,oc)=sum(restr_W_conv_tmp,4);
			
			
			
			
		end   % of the loop over the central (reference) orientation
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		%%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% we generalize Z.Li's formula for the normalization by suming
		% over all the scales within a given hypercolumn (cf. p209, where she
		% already sums over all the orientations) 
		
% 		sum_newgx_toroidal_x=sum(sum(newgx_toroidal_x,3),4); % Xavier. No tinc clar que sigui una suma, sino mes aviat una mitja
		sum_newgx_toroidal_x=sum(sum(newgx_toroidal_x(:,:,radius_sc+1:radius_sc+n_scales,:),3),4); % Xavier. No tinc clar que sigui una suma, sino mes aviat una mitja
		sum_newgx_toroidal_x=sum_newgx_toroidal_x/1;
		
		kk=convolucio_optima(sum_newgx_toroidal_x(Delta-1:M+Delta+2,Delta-1:N+Delta+2),M_norm_conv,0,0); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
% 		kk=convolucio_optima(sum_newgx_toroidal_x(Delta-1:M+Delta+2,Delta-1:N+Delta+2),M_norm_conv*inv_den,0,0); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
		I_norm_base=kk(2+1:M+2,2+1:N+2,:);
		I_norm_base=-2*(I_norm_base*inv_den).^r;

		if XOP_DEBUG
			show_x_y(fig,x,y,I_norm_base);
% 			I_norm_base=I_norm_base*0; % Xavier. I_norm=0;

		end
		
		for s=1:n_scales  % use repmat instead !!!!
			for o=1:K
				I_norm(:,:,:,o)=I_norm_base;
			end
		end
		%%%%%%%%%%%%%% end normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		
		
		
		%%%%%%%%% CENTRAL FORMULA (formulae (1) and (2) p.192) %%%%%%

		x_old=x;
		% (1) excitatory neurons
			x=x+prec*(-alphax*x...				% decay
				-newgy(y)...
				-x_ei...						% ei term
				+J0*newgx(x)... % input
				+x_ee...
				+Iitheta{t_membr}... % Iitheta: should be deinfed!!!!
				+I_norm...				% normalization
				+0.85);             % spontaneous firing rate?
			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for speed)
			
			
			
		% (2) inhibitory neurons
			y=y+prec*(-alphay*y...     % decay
				+newgx(x_old)...
				+y_ie...
				+1);     % spontaneous firing rate?
			%+0.1*(rand(M,N,n_scales,K)));...   % neural noise (comment for
			%speed)
%		end
				
		
% 		disp('questions: verify that the newgy(y) newgx(x) are not in the expressions y_ei,x_ei,x_ee ')
	end % end t_iter=1:n_iter	
toc
	%if t*prec==ceil(t*prec) % added 1/2/12
	
	

	
		gx_final{t_membr}=newgx(x); % was gx_final(:,:,:,t)=newgx(x(:,:,:));
		
		gy_final{t_membr}=newgy(y);

end  % end t_membr=1:t_membr
	
% Si l'output es la senyal processada
% 	[gx_final]=curv_denormalization(gx_final,struct,normal_max,normal_min);

	
end


