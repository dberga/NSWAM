function [gx_final] = Rmodelinductiond_v0_3(Iitheta,struct)

%-------------------------------------------------------

% scale=wav.scale;
% orient=wav.orient;

wave=struct.wave;

use_fft=struct.compute.use_fft;

n_scales=wave.n_scales;

% make the structure explicit
zli=struct.zli;
compute=struct.compute;

% struct.zli
% differential equation
n_membr=zli.n_membr;
n_iter=zli.n_iter;
prec=1/n_iter;
% prec=zli.prec;
% normalization
normal_input=zli.normal_input;
dist_type=zli.dist_type;
%var_noise=0.1*2*normal_input/4;
var_noise=0.1*2;
% zli.normal_output=2.0;
% 
% 
% zli.ON_OFF=0; % 0: separate, 1: abs, 2:square
% zli.nu_0=2;

% Delta
Delta=zeros(n_scales);

switch (wave.multires)
	case 'a_trous'
		if compute.scale_interaction_debug==1
			Delta=zli.Delta.*ones(1,n_scales);
		else
% 			Delta=zli.Delta*2.^((1:n_scales)-1);
			Delta=zli.Delta*scale2size(1:n_scales,zli.scale2size_type);
		end
	case 'a_trous_contrast'
% 		Delta=zli.Delta*2.^((1:n_scales)-1);
			Delta=zli.Delta*scale2size(1:n_scales,zli.scale2size_type);
	otherwise
		disp('ERRORRR!!!!!!!!!!!!!!!!!!!!!!!! no sabem com fer la Delta');
end
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
%  		Iitheta{i}=Iitheta{i}*0;

		
% 		for ii=N/2:N/2
% 			for jj=1:M
% 				Iitheta{i}(jj,ii,1,1)=1;
% 			end
% 		end

% 		for ii=-10:10
% 			for jj=-10:10
% 				Iitheta{i}(floor(M/2)+ii,floor(N/2)+jj,1,1)=1;
% 				Iitheta{i}(floor(M/2)+ii,floor(N/2)+jj,2,1)=1;
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


for i=1:n_membr
	Iitheta_2=Iitheta{i}(:,:,:,2);
	Iitheta{i}(:,:,:,2)=Iitheta{i}(:,:,:,3);
	Iitheta{i}(:,:,:,3)=Iitheta_2;
end


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

% % prepare the coefficient of the excitatory and inhibitory contributions
% % the masks are given by 3Mx3NxK matrices (like for Itheta)
% 
% %M_exc=zeros(1,3*N,K);
% %M_inh=zeros(1,3*N,K);
% 
% % for a two dimensional stimulus
% % Delta=15; % maximum radius of the area of influence
% %Delta=sqrt(max(de,di))*3;
% 
diam=2*Delta+1; % maximum diameter of the area of influence
% 
% xx=repmat((Delta:-1:-Delta),2*Delta+1,1);
% yy=repmat((Delta:-1:-Delta)',1,2*Delta+1);
% 
% d=zeros(diam,diam);
% d=sqrt(xx.*xx+yy.*yy);
% 
% 
% 
% % 1-d to 2-d modification
% % kappa=0.6706/4.4096;   % commented 29/11/11 (all in genpar.str)
% % verify we heritate a code which is coherent with v3
% ver=0;
% 
% 
% % M_exc_conv=kappa1*0.126.*exp(-d.^2/de);
% % M_inh_conv=kappa2*0.126.*exp(-d.^2/di);
% % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Normalization mask %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% M_normalization=zeros(1,3*N,K);
% 
% % one dimensional normalization mask
% M_normalization_base=[zeros(1,8),ones(1,5),zeros(1,17)];
% M_normalization(1,1:30)=M_normalization_base;
% M_normalization=circshift(M_normalization,[0 N+1-11]);

% two_dimensional


[M_norm_conv,inv_den]=Fer_M_norm_conv(n_scales,dist_type,zli.scale2size_type);

% M_norm_conv(3,3)=0;
% den=24;
% inv_den=1/24;

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
n_weight_scales=1+2*radius_sc;

if(zli.scale_interaction==1)
	switch(wave.multires)
		case('gabor_HMAX')
			e=0.01; % e=0.11 es el tall entre fase i contrafase
			f=1;
		otherwise
			e=0.01;
			f=1;
	end

else
	e=0;
	f=1;
end

weight_scales=[e*e f*f e*e];
border_weight=get_border_weights(e,f);


Delta_ext=zeros(1,n_scales+radius_sc*2);

Delta_ext(radius_sc+1:n_scales+radius_sc)=Delta;
Delta_ext(1:radius_sc)=Delta(1);
Delta_ext(n_scales+radius_sc+1:n_scales+radius_sc*2)=Delta(n_scales);



if radius_sc>1
	disp('COMPTEEEEE!!!!!! border_weights nomes considera radius_sc=1, i ara es radius_sc>1 !!!!!!!');
end

% define the filter
scale_filter=zeros(1,1,1+2*radius_sc,1);
scale_filter(1,1,:,1)=weight_scales;
scale_filter_other=scale_filter;
scale_filter_other(1,1,1+radius_sc,1)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%        prepare J_ithetajtheta' and J_ithetajtheta       %%%%%%%%%%%%
%%%%%             for x_ee    and y_ie								%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_J=cell(n_scales,1);
all_W=cell(n_scales,1);
all_J_fft=cell(n_scales,1);
all_W_fft=cell(n_scales,1);

half_size_filter=cell(n_scales,1);

for s=1:n_scales
	all_J{s}=zeros(diam(s),diam(s),K,K);
	all_W{s}=zeros(diam(s),diam(s),K,K);
	for o=1:K
		[all_J{s}(:,:,:,o),all_W{s}(:,:,:,o)]=get_Jithetajtheta_v0_4(s,K,o,Delta(s),wave,zli);
	end
% 	J=zeros(diam,diam,1,K,K);
% 	W=zeros(diam,diam,1,K,K);
	
% 	J(:,:,1,:,:)=all_J{s};
% 	all_J{s}=J;
% 	W(:,:,1,:,:)=all_W{s};
% 	all_W{s}=W;
% 	
	
end	
	% scales (cf. above )
if XOP_DEBUG
	veure_J_W(all_J,all_W,K);
end
	
for s=1:n_scales
	
	if radius_sc >0
		J=zeros(diam(s),diam(s),1,K,K);
		W=zeros(diam(s),diam(s),1,K,K);
% 		for ss=1:radius_sc*2+1
% 			ii=s-radius_sc-1+ss;
% 			if ii<1 
% 				ii=1-ii+1;
% 			end
% 			J(:,:,ss,:,:)=weight_scales(ss)*all_J{ii}(:,:,:,:);
% 			W(:,:,ss,:,:)=weight_scales(ss)*all_W{ii}(:,:,:,:);
% 		end
% 		half_size_filter{s}=[Delta(s) Delta(s) radius_sc];
		half_size_filter{s}=[Delta(s) Delta(s) 0];
			J(:,:,1,:,:)=1*all_J{s}(:,:,:,:);
			W(:,:,1,:,:)=1*all_W{s}(:,:,:,:);
		all_J{s}=J;
		all_W{s}=W;
	end
	
	
	% A Matrix for each scale
	
	% FFT
	
	if (use_fft)	
		
		all_J_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
		all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
		
		for ov=1:K
			for oc=1:K
				all_J_fft{s}(:,:,1,ov,oc)=fftn(all_J{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
				all_W_fft{s}(:,:,1,ov,oc)=fftn(all_W{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
			end
		end

% 		all_J_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc,K,K);
% 		all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc,K,K);
% 		
% 		for ov=1:K
% 			for oc=1:K
% 				all_J_fft{s}(:,:,:,ov,oc)=fftn(all_J{s}(:,:,:,ov,oc),[M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc]);
% 				all_W_fft{s}(:,:,:,ov,oc)=fftn(all_W{s}(:,:,:,ov,oc),[M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc]);
% 			end
% 		end
% 		% 	half_size_filter=[Delta Delta 0];

	
	
	end
	

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Nadal's diagnostics
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% if nargout==3
%    inh_energy=zeros(K,niter);
% end   

% ones_M_N=ones(M,N);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% the loop over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=size(Iitheta{1},4);

% preallocate
x=Iitheta{1}; % visual input (Iitheta) initializes the activity levels newgx(x) (p.192)
y=zeros(M,N,n_scales,K);
% preallocate for speed
% J_conv_tmp=zeros(M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc,K);
% W_conv_tmp=zeros(M+2*Delta(s),N+2*Delta(s),n_scales+2*radius_sc,K);

if XOP_DEBUG
% 	scrsz = get(0,'ScreenSize');
% 	figure('Name','x','Position',[1 scrsz(4) N M]);title('x');fig_x=gcf;kk=get(fig_x,'Position');f_ampl=kk(3);f_alc=kk(4);
% 	figure('Name','y','Position',[1+f_ampl scrsz-f_alc N M]);title('y');fig_y=gcf;
% 	figure('Name','newgx');title('newgx');fig_newgx=gcf;
% 	figure('Name','newgy');title('newgy');fig_newgy=gcf;
% 	figure('Name','I_norm');title('I_norm');fig_I_norm=gcf;
			for s=1:min(3,n_scales)
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
% fig_plot=figure;
		
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
		
		toroidal_x=cell(n_scales+2*radius_sc,1);
		toroidal_y=cell(n_scales+2*radius_sc,1);

		for s=1:n_scales

			% mirror boundary condition
			toroidal_x{s+radius_sc}=padarray(x(:,:,s,:),[Delta(s),Delta(s),0],'symmetric');
			toroidal_y{s+radius_sc}=padarray(y(:,:,s,:),[Delta(s),Delta(s),0],'symmetric');
			
% 			toroidal_x{s}=padarray(toroidal_x{s},[0,0,radius_sc,0],0);
% 			toroidal_y{s}=padarray(toroidal_y{s},[0,0,radius_sc,0],0);
		end	% of the loop over scales
			
		
		
			% Assignar valors al pad de les escales
			
			% 	toroidal_x(:,:,1:1+radius_sc,:)=border_weight(1).*toroidal_x(:,:,1+radius_sc,:)+...
			% 		border_weight(2).*toroidal_x(:,:,1+radius_sc+1,:)

			kk_tmp1=zeros(size(toroidal_x{radius_sc+1})); % El dia que ho generalitzem haura de ser 1:radius_sc
			kk_tmp2=zeros(size(toroidal_x{n_scales+radius_sc}));
			kk_tmp1_y=zeros(size(toroidal_y{radius_sc+1})); % El dia que ho generalitzem haura de ser 1:radius_sc
			kk_tmp2_y=zeros(size(toroidal_y{n_scales+radius_sc}));
				

			disp(['t_iter: ' int2str(t_iter)]);
			
			
			newgx_toroidal_x=cell(n_scales+2*radius_sc,1);
			newgy_toroidal_y=cell(n_scales+2*radius_sc,1);
			restr_newgx_toroidal_x=zeros(M,N,n_scales+2*radius_sc,K);
			restr_newgy_toroidal_y=zeros(M,N,n_scales+2*radius_sc,K);
			
			for s=1:n_scales+2*radius_sc
% 			for s=1:n_scales
				newgx_toroidal_x{s}=newgx(toroidal_x{s});
				newgy_toroidal_y{s}=newgy(toroidal_y{s});
				
			end

			
			for i=1:radius_sc+1
				
% 				for ss=1:radius_sc+1
% % 					kk_tmp1=kk_tmp1+border_weight(i)*padarray(toroidal_x{radius_sc+i}(:,:,:),[Delta(radius_sc+1)-Delta(i),Delta(i+1)-Delta(1),0],'symmetric');
% % 					kk_tmp2=kk_tmp2+border_weight(i)*padarray(toroidal_x{n_scales+i-1}(:,:,:),[Delta(n_scales)-Delta(n_scales-1),Delta(n_scales)-Delta(n_scales-1),0],'symmetric');
% 				end
				
				kk_tmp1(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)=kk_tmp1(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)+border_weight(i) * newgx_toroidal_x{radius_sc+i}(Delta(i)+1:Delta(i)+M,Delta(i)+1:Delta(i)+N,:);
				kk_tmp2(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)=kk_tmp2(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)+border_weight(i) * newgx_toroidal_x{n_scales+radius_sc-(i-1)}(Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+M,Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+N,:);
				kk_tmp1_y(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)=kk_tmp1_y(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)+border_weight(i) * newgy_toroidal_y{radius_sc+i}(Delta(i)+1:Delta(i)+M,Delta(i)+1:Delta(i)+N,:);
				kk_tmp2_y(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)=kk_tmp2_y(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)+border_weight(i) * newgy_toroidal_y{n_scales+radius_sc-(i-1)}(Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+M,Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+N,:);
				
			end
			
			newgx_toroidal_x{1:radius_sc}=kk_tmp1;
			newgx_toroidal_x{n_scales+radius_sc+1:n_scales+2*radius_sc}=kk_tmp2; % ??????????????????????
			
			newgy_toroidal_y{1:radius_sc}=kk_tmp1_y;
			newgy_toroidal_y{n_scales+radius_sc+1:n_scales+2*radius_sc}=kk_tmp2_y; % ??????????????????????
			
			
			
			for s=1:n_scales+2*radius_sc
				restr_newgx_toroidal_x(:,:,s,:)=newgx_toroidal_x{s}(Delta_ext(s)+1:Delta_ext(s)+M,Delta_ext(s)+1:Delta_ext(s)+N,:);
				restr_newgy_toroidal_y(:,:,s,:)=newgy_toroidal_y{s}(Delta_ext(s)+1:Delta_ext(s)+M,Delta_ext(s)+1:Delta_ext(s)+N,:);
			end

			
			
			
			
			
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
				
% 				restr_sum_scale_newgy_toroidal_y=sum_scale_newgy_toroidal_y(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);

				sum_scale_newgy_toroidal_y=convolucio_optima(restr_newgy_toroidal_y,scale_filter,0,0); % does it give the right dimension? 'same' needed?
				restr_sum_scale_newgy_toroidal_y=sum_scale_newgy_toroidal_y(:,:,radius_sc+1:radius_sc+n_scales,:); % restriction over scales
				w=zeros(1,1,1,K);w(1,1,1,:)=PsiDtheta(oc,:);
				
% 				x_ei(:,:,:,oc)=sum(restr_sum_scale_newgy_toroidal_y.*repmat(w,[M,N,n_scales,1]),4)-restr_sum_scale_newgy_toroidal_y(:,:,:,oc);
				x_ei(:,:,:,oc)=sum(restr_sum_scale_newgy_toroidal_y.*repmat(w,[M,N,n_scales,1]),4);
				
				
				% convolucio amb una "barreta" de dimensio 1 donada per Psi
				% 				x_ei=convolucio_optima(newgy(y_int)(x,y,:),Psi(Dtheta));
				% proves:  newgy_y_int=rand(20,20,n_scales,3);
				
				
				
				
				
				% excitatory and inhibitory terms (the big sums)
				% excitatory-excitatory term:    x_ee
				% excitatory-inhibitory term:    y_ie
				
				x_ee_conv_tmp=zeros(M,N,n_scales,K);
				y_ie_conv_tmp=zeros(M,N,n_scales,K);

				for ov=1:K  % loop over all the orientations given the central (reference orientation)
					
					
					
					
					% 					[all_J(:,:,:,o),all_W(:,:,:,o)]=get_Jithetajtheta(M,N,K,o,Delta,wave.multires);
					
					if XOP_DEBUG
						% 					W_ov=all_W(:,:,:,ov,oc)*0; %Xavier: Desactivem inhibicio
					end
					
					%J_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),J_ov);
					%W_conv_tmp(:,:,ov)=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),W_ov);
					
					
					% FFT
					if (use_fft)
						for s=1:n_scales
							kk=convolucio_optima(newgx_toroidal_x{radius_sc+s}(:,:,ov),all_J_fft{s}(:,:,1,ov,oc),half_size_filter{s},1);  % (max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)
							x_ee_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
% 							restr_J_conv_tmp=x_ee_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);
							
							% Per debugar i comparar la FFT amb la convn
							%  					kk_conv=convolucio_optima(newgx_toroidal_x(:,:,:,ov),J_ov,0,0);
							% 					restr_kk_conv=kk_conv(Delta+1:M+Delta,Delta+1:N+Delta,radius_sc+1:radius_sc+n_scales);
							%  					dif=restr_J_conv_tmp(:,:,:,ov)-restr_kk_conv;
							% 					sc=2;
							% 					figure;imagesc(restr_J_conv_tmp(:,:,sc,ov));colormap('gray');
							% 					figure;imagesc(restr_kk_conv(:,:,sc));colormap('gray');
							% 					figure;imagesc(dif(:,:,sc));colormap('gray');
							% ========
							
% 							W_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),all_W_fft(:,:,:,ov,oc),half_size_filter,1);
% 							restr_W_conv_tmp=W_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);

							kk=convolucio_optima(newgx_toroidal_x{radius_sc+s}(:,:,ov),all_W_fft{s}(:,:,1,ov,oc),half_size_filter{s},1);  % (max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)
							y_ie_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
						end
						
					else
						disp('Part no adaptada 1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!');
						J_ov=all_J(:,:,:,ov,oc);
						W_ov=all_W(:,:,:,ov,oc);
						J_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),J_ov,0,0);  % (max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)
						restr_J_conv_tmp=J_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);
						W_conv_tmp(:,:,:,ov)=convolucio_optima(newgx_toroidal_x(:,:,:,ov),W_ov,0,0);
						restr_W_conv_tmp=W_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);
					end
					
				end
				
				x_ee(:,:,:,oc)=sum(x_ee_conv_tmp,4);
				y_ie(:,:,:,oc)=sum(y_ie_conv_tmp,4);
				
				
				
				
			end   % of the loop over the central (reference) orientation
		
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		%%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% we generalize Z.Li's formula for the normalization by suming
		% over all the scales within a given hypercolumn (cf. p209, where she
		% already sums over all the orientations) 
% 		sum_newgx_toroidal_x=cell(n_scales,1);
		I_norm=zeros(M,N,n_scales,K);		

		disp('Compte!!!!!!! No calculem I_norm incloent les escales !!!!!');
% 		sum_newgx_toroidal_x=cell(n_scales,1);
% 		
% 		for s=radius_sc+1:radius_sc+n_scales
% 			sum_newgx_toroidal_x{s}(:,:,:)=convolucio_optima(newgx_toroidal_x{s},scale_filter,0,0); 
% 		end
 		for s=radius_sc+1:radius_sc+n_scales
% 			radi=2^(s-radius_sc);
% 			radi=scale2size(s-radius_sc,zli.scale2size_type);
			radi=(size(M_norm_conv{s-radius_sc})-1)/2;
			sum_newgx_toroidal_x_sc=sum(newgx_toroidal_x{s},4);
			sum_newgx_toroidal_x=repmat(sum_newgx_toroidal_x_sc,[1 1 K]);
			
			kk=convolucio_optima(sum_newgx_toroidal_x(Delta_ext(s)+1-radi(1):Delta_ext(s)+M+radi(1),Delta_ext(s)+1-radi(2):Delta_ext(s)+N+radi(2),:),M_norm_conv{s-radius_sc},0,0); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
			I_norm(:,:,s-radius_sc,:)=kk(radi(1)+1:M+radi(2),radi(1)+1:N+radi(2),:);
		end
		
 		for s=1:n_scales
			I_norm(:,:,s,:)=-2*(I_norm(:,:,s,:)*inv_den{s}).^r;
		end

		
% 		for s=1:n_scales  % use repmat instead !!!!
% 			for o=1:K
% 				I_norm(:,:,:,o)=I_norm_base;
% 			end
% 		end
		%%%%%%%%%%%%%% end normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		
		
		
		%%%%%%%%% CENTRAL FORMULA (formulae (1) and (2) p.192) %%%%%%

% 		x_old=x;

		% (1) inhibitory neurons
			y=y+prec*(-alphay*y...     % decay
				+newgx(x)...
				+y_ie...
				+1.0...     % spontaneous firing rate?
			+var_noise*(rand(M,N,n_scales,K))-0.5);  % neural noise (comment for speed
% 				+1.0);     % spontaneous firing rate?
% %		end

		
		% (2) excitatory neurons
			x=x+prec*(-alphax*x...				% decay
				-x_ei...						% ei term
				+J0*newgx(x)... % input
				+x_ee...
				+Iitheta{t_membr}... % Iitheta: should be deinfed!!!!
				+I_norm...				% normalization
				+0.85...             % spontaneous firing rate?
			+var_noise*(rand(M,N,n_scales,K))-0.5);   % neural noise (comment for speed)
% 				+0.85);             % spontaneous firing rate?
% 				-newgy(y)...


			
		if XOP_DEBUG
			show_x_y(fig,x,y,I_norm,Iitheta{t_membr},n_scales);
% 			show_x_y(fig,x,x_ei,x_ee,y_ie,n_scales);
% 			I_norm_base=I_norm_base*0; % Xavier. I_norm=0;

		end
			
				
% 		figure(fig_plot);
% 		max_x_ee(t_iter)=max(x_ee(:));
% 		max_x_ei(t_iter)=max(x_ei(:));
% 		max_y_ie(t_iter)=max(y_ie(:));
% 		min_I_norm(t_iter)=min(I_norm(:));
% 		max_x(t_iter)=max(x(:));
% 		max_y(t_iter)=max(y(:));
% 		plot(max_x_ee,'r+');hold on;
% 		plot(max_x_ei,'g+');hold on;
% 		plot(max_y_ie,'b+');hold on;
% 		plot(min_I_norm,'k+');hold on;
% 		plot(max_x,'ro');hold on;
% 		plot(max_y,'go');hold on;

% 		disp('questions: verify that the newgy(y) newgx(x) are not in the expressions y_ei,x_ei,x_ee ')
	end % end t_iter=1:n_iter	
% 	ginput(1);
toc
	%if t*prec==ceil(t*prec) % added 1/2/12
	
	

	
		gx_final{t_membr}=newgx(x); % was gx_final(:,:,:,t)=newgx(x(:,:,:));
		
		gy_final{t_membr}=newgy(y);

end  % end t_membr=1:t_membr
	
% Si l'output es la senyal processada
% 	[gx_final]=curv_denormalization(gx_final,struct,normal_max,normal_min);

	
end


