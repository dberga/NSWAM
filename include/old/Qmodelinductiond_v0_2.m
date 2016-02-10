function [gx_final,gy_final,inh_energy] = Qmodelinductiond_v0_2(im,struct,wav)

%-------------------------------------------------------

scale=wav.scale;
orient=wav.orient;

% make the structure explicit
zli=struct.zli;
% compute=struct.compute;

% struct.zli
% differential equation
niter=zli.niter;
prec=zli.prec;
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
%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alphax=zli.alphax;
alphay=zli.alphay;
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
Iitheta=zeros(M,N,K);
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

M_exc=zeros(1,3*N,K);
M_inh=zeros(1,3*N,K);

% for a two dimensional stimulus
% Delta=15; % maximum radius of the area of influence
%Delta=sqrt(max(de,di))*3;

diam=2*Delta+1; % maximum diameter of the area of influence

xx=repmat([(Delta:-1:1),(0:Delta)],2*Delta+1,1);
yy=repmat([(Delta:-1:1),(0:Delta)]',1,2*Delta+1);
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Excitation and inhibition %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M_exc_conv=zeros(size(d));
M_inh_conv=zeros(size(d));

if(K==1)
	Dtheta=0; % Only when K=1
else
	disp('ERROR!!! ... K~=1, no puc definir theta1!!!!!');
end

switch(orient)
	case(1)
		theta=pi/2;
		thetap=pi/2;
	case(2)
		theta=0;
		thetap=0;
	case(3)
		theta=pi/4;
		thetap=pi/4;
end

c=complex(xx,yy);
angline=angle(c);
theta1=theta-angline;
theta2=thetap-angline;


beta=2*abs(theta1)+2*sin(abs(theta1+theta2)); % Hi ha diferencia entre Li i Machecler !!!!

% J: Excitation

ii=find((d>0 & d<=10 & beta<pi/2.69) | (d>0 & d<=10 & beta<pi/1.1) & (abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9 ));
M_exc_conv(ii)=kappa1*0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-d(ii).*d(ii)/90);

% W: Inhibition

jj=find(~(d==0 | d>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) );
% jj=find(~(d==0 | d/cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) ); % Diferencia entre Li i Machecler
M_inh_conv(jj)=kappa2*0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(Dtheta/(pi/4))^1.5);



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

% nothing to do here
% Iitheta=im;
% in this version, there is sth to do: we only have as many image as nb of
% membrane time constant so we have to expand the stimulus to a niter/prec
B=zeros(M,N,1,niter);B(:,:,1,:)=im;
C=repmat(B,[1,1,1/prec,1]);
Iitheta=reshape(C,M,N,[]);
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
        % loop? another idea? yes, resize...
        [xa,yb,zc]=size(im);
        zc=1;  % I think it's sufficient (only the first frame should be taken into consideration here!)
        % toroidal_Iitheta=zeros(xa,yb,zc);
        for iii=1:zc
            toroidal_Iitheta(:,:,iii)=repmat([fliplr(im(:,:,iii)),im(:,:,iii),fliplr(im(:,:,iii))],3,1);
        end    
        newgx_toroidal_Iitheta=newgx(toroidal_Iitheta(:,:,1)); % no change for the first frame
% end        

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
for t=1:(niter/prec)  % t gives the membrane time constant

    
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
            kk=convolucio_optima(newgx_toroidal_x(max(1,M+1-diam):min(3*M,2*M+diam),max(1,N+1-diam):min(3*N,2*N+diam)),M_inh_conv);
            y_int(:,:,k)=kk(diam+1:end-diam,diam+1:end-diam);
        end

        kk=convolucio_optima(newgx_toroidal_x,M_norm_conv);

        I_norm(:,:,k)=kk(M+1:2*M,N+1:2*N);
        I_norm(:,:,k)=-2*(I_norm(:,:,k).*inv_den).^r;

                

                
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
                    if t==1
                       x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
                                         J0*newgx(Iitheta(:,:,k,t))+...
                                         x_int(:,:,k)+...
                                         Iitheta(:,:,k,t)+...                                     % the image
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
                        x(:,:,k)=x(:,:,k)+prec*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
                                         J0*newgx(x(:,:,k))+...
                                         x_int(:,:,k)+...
                                         Iitheta(:,:,t)+...                                     % the image
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
                       y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(Iitheta(:,:,t))+...
                                         y_int(:,:,k)+...
                                         ones_M_N+...
                                         0.1*(rand(M,N)-0.5)); 
                    else    
                       y(:,:,k)=y(:,:,k)+prec*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
                                         y_int(:,:,k)+...
                                         ones_M_N+...
                                         0.1*(rand(M,N)-0.5));
                    end
%       end % of the dynamic/constant structure ---------------------------------------
   end
   
% if dynamic~=1   
%         % Non-dynamic case: store the values at any multiples of the membrane time constant
%         if t*prec==ceil(t*prec)
%               gx_final(:,:,:,t*prec)=newgx(x(:,:,:));
%               gy_final(:,:,:,t*prec)=newgy(y(:,:,:));
%         end
% else    
        % Dynamic case: store the values at any membrane time constant
        if t*prec==ceil(t*prec) % added 1/2/12
            gx_final(:,:,:,t*prec)=newgx(x(:,:,:)); % was gx_final(:,:,:,t)=newgx(x(:,:,:));
            gy_final(:,:,:,t*prec)=newgy(y(:,:,:));
        end
% end        
   

end


    

