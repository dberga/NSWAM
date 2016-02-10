function [gx_final,gy_final,inh_energy] = Qmodelinduction_v4_0(im,struct,n,scale)

%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;

% struct.zli
% differential equation
n_iter=zli.niter;
curvdt=zli.prec;
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


de=zli.dedi(1,scale,n);
di=zli.dedi(2,scale,n);
%-------------------------------------------------------

% modif 
% sigma1=1./sqrt(pi.*de);
% sigma2=1./sqrt(pi.*di);
sigma1=1;
sigma2=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alphax=1;
alphay=1;
% the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
K=1; % no orientation here

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
x=zeros(M,N,K);
y=zeros(M,N,K);
gx_final=zeros(M,N,K,n_iter);
gy_final=zeros(M,N,K,n_iter);
Iitheta=zeros(M,N,K);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% prepare the excitatory and inhibitory masks %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare the coefficient of the excitatory and inhibitory contributions
% the masks are given by 3Mx3NxK matrices (like for Itheta)

M_exc=zeros(1,3*N,K);
M_inh=zeros(1,3*N,K);

% for a two dimensional stimulus
% Delta=15; % maximum radius of the area of influence
%Delta=sqrt(max(de,di))*3;
diam=2*Delta+1; % maximum diameter of the area of influence
d=repmat([(Delta:-1:1),(0:Delta)],2*Delta+1,1);
d=d+d';

% 1-d to 2-d modification
% kappa=0.6706/4.4096;   % commented 29/11/11 (all in genpar.str)
% verify we heritate a code which is coherent with v3
ver=0;
M_exc_conv=sigma1.*kappa1*0.126.*exp(-d.^2/de);
if ver
    verify=zeros(size(M_exc_conv));
    verify((size(M_exc_conv,1)+1)/2,:)=M_exc_conv((size(M_exc_conv,1)+1)/2,:)./kappa; % maximum radius of the area of influence
    M_exc_conv=verify;
end
M_inh_conv=sigma2.*kappa2*0.126.*exp(-d.^2/di);
if ver
    verify=zeros(size(M_inh_conv));
    verify((size(M_exc_conv,1)+1)/2,:)=M_inh_conv((size(M_exc_conv,1)+1)/2,:)./kappa;
    M_inh_conv=verify;
end    


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

% nothing to do here
Iitheta=im;
% toroidal boundary condition
%   toroidal_Iitheta=repmat(Iitheta,3,3);
 
% mirrored boundary
toroidal_Iitheta=[fliplr(im),im,fliplr(im)];
toroidal_Iitheta=repmat(toroidal_Iitheta,3,1);

newgx_toroidal_Iitheta=newgx(toroidal_Iitheta);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Nadal's diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

if nargout==3
   inh_energy=zeros(K,n_iter);
end   

ones_M_N=ones(M,N);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% the loop over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:(n_iter/curvdt)  % t gives the membrane time constant

    
   % (toroidal=wrapping around)/mirror boundary condition 
   if strcmp(boundary,'wrap')
      toroidal_x=repmat(x,3,3); 
   elseif strcmp(boundary,'mirror')
       a=zeros(M,N,K);%b=zeros(M,N,K);c=zeros(M,N,K);
       %prepare the mirrored matrices (fliplr/ud don't work for size > 2...)
       for i=1:K
           a(:,:,i)=fliplr(x(:,:,i));
           %b(:,:,i)=flipud(x(:,:,i));
           %c(:,:,i)=flipud(fliplr(x(:,:,i)));
       end    
      toroidal_x=[a,x,a];
      toroidal_x=repmat(toroidal_x,3,1);
   end            
       

newgx_toroidal_x=newgx(toroidal_x);
x_int=zeros(M,N,K);
y_int=zeros(M,N,K);
I_norm=zeros(M,N,K);

               

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%% excitation-inhibition %%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
   for k=1:K
        if t==1
            kk=convolucio_optima(newgx_toroidal_Iitheta(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_exc_conv);
            x_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
            kk=convolucio_optima(newgx_toroidal_Iitheta(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_inh_conv);
            y_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
        else
            kk=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_exc_conv);
            x_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
            kk=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*N,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_inh_conv);
            y_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
        end

        kk=convolucio_optima(newgx_toroidal_x,M_norm_conv);

        I_norm(:,:,k)=kk(M+1:2*M,N+1:2*N);
        I_norm(:,:,k)=-2*(I_norm(:,:,k).*inv_den).^r;

                

                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%% normalization process %%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
        
      % Iteration step (t -> t+1)
        if t==1
           x(:,:,k)=x(:,:,k)+curvdt*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
                             J0*newgx(Iitheta(:,:,k))+...
                             x_int(:,:,k)+...
                             Iitheta(:,:,k)+...                                     % the image
                             0.85*ones_M_N+...
                             I_norm(:,:,k)+...
                             0.1*(rand(M,N)-0.5));
           % energy of inhibition              
           if nargout==3
              inh_energy(k,t)=sum(sum((newgy(y(:,:,k))+Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
                             newgy(y(:,:,Difftheta(k,2))))+...
                             Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
                             newgy(y(:,:,Difftheta(k,4))))).^2));
           end              
    
       else    
            x(:,:,k)=x(:,:,k)+curvdt*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
                             J0*newgx(x(:,:,k))+...
                             x_int(:,:,k)+...
                             Iitheta(:,:,k)+...                                     % the image
                             0.85*ones_M_N+...
                             I_norm(:,:,k)+...
                             0.1*(rand(M,N)-0.5));
           % energy of inhibition              
           if nargout==3
              inh_energy(k,t)=sum(sum((Psi(pi/K)*(newgy(y(:,:,Difftheta(k,1)))+...
                             newgy(y(:,:,Difftheta(k,2))))-...
                             Psi(2*pi/K)*(newgy(y(:,:,Difftheta(k,3)))+...
                             newgy(y(:,:,Difftheta(k,4))))).^2));
           end
        end
    
    
        if t==1
           y(:,:,k)=y(:,:,k)+curvdt*(-alphay*y(:,:,k)+newgx(Iitheta(:,:,k))+...
                             y_int(:,:,k)+...
                             ones_M_N+...     
                             0.1*(rand(M,N)-0.5)); 
        else    
           y(:,:,k)=y(:,:,k)+curvdt*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
                             y_int(:,:,k)+...
                             ones_M_N+...     
                             0.1*(rand(M,N)-0.5));
        end
    
   end
   
   
% Remember the values at any multiples of the membrane time constant
if t*curvdt==ceil(t*curvdt)
      gx_final(:,:,:,t*curvdt)=newgx(x(:,:,:));
      gy_final(:,:,:,t*curvdt)=newgy(y(:,:,:));
end
   

end


    

