function [gx_final,gy_final,inh_energy] = Qmodelinduction_v3_1(im,curvdt,n_iter,r,boundary,de,di)

% v3 from Qmodelinduction_v2

% v2, excitation and inhibition connections can be set (de and di parameters)
%
% im: input_data
% curvdt: precision for euler convergence (tipically 0.1-0.01)
% n_iter: number of iterations
% r: 2
% boundary: edges processing (values: 'mirror', 'wrap')
% de: excitation neighbour range
% di: inhibition neighbour range
%
% From RZLimodel on 11/9/10. Aim: induction.
% One-dimension reduction.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Above: changes during course 2010-2011



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alphax=1;
alphay=1;
% the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
K=1; % no orientation here


% self-excitation coefficient
J0=0.8;

% useful but certainly not elegant (provide the "first" and second neigh. of the orientation determined
% by the row number: for orientation 1, i.e. pi/12, the non-zero
% contribution are given by 1, then 2 and 12,
% then 3 and 11)

%Difftheta=[[12;(1:11)'],[(2:12)';1],[11;12;(1:10)'],[(3:12)';1;2]];


% grid dimensions and number of preferred orientation in the hypercolumn
M=size(im,1);
N=size(im,2);

if M ~=1
   disp('Error, stimulus should be one-diemnsional!')
end   

if N <= 10
   disp('bad stimulus dimensions, the toroidal boundary conditions are ill-defined')
end


% the membrane potentials
x=zeros(M,N,K);
y=zeros(M,N,K);
gx_final=zeros(M,N,K,n_iter);
gy_final=zeros(M,N,K,n_iter);
Iitheta=zeros(M,N,K);


% visual input Iitheta persits after onset, [and initializes the activity levels
% gx(xitheta)] the [] part is not clear to me
% Here, we compute the Iitheta

% preparation of the function Phi

% Phi=zeros(1,K);
% for kk=1:K
%     Phi(kk)=exp(-(kk-1)/(pi/8));
% end    
%     Phi_reverse=fliplr(Phi);
%     Phi_reverse(12)=0;
%     Phi_reverse=[0,Phi_reverse(1:11)];
% remark the solution proposed here is very general but useless since Phi
% decreases very fast


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% prepare the excitatory and inhibitory masks %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare the coefficient of the excitatory and inhibitory contributions
% the masks are given by 3Mx3NxK matrices (like for Itheta)

M_exc=zeros(1,3*N,K);
M_inh=zeros(1,3*N,K);

% the reference position is (1,1,1), put at the entry (1,11,1)
d=[fliplr(1:10),(0:9),10,zeros(1,9)];
% previous versions de was 90
M_exc_base=0.126.*exp(-d.^2/de);
M_exc_conv=M_exc_base(1:21);
M_exc_base(1,22:30)=zeros(1,9);
% put M_exc_base at the right place
M_exc(1,1:30)=M_exc_base;
M_exc=circshift(M_exc,[0 N+1-11]);

% PROBLEM?????? inhibitory mask?
M_inh_base=0.126.*exp(-d.^2/di);
M_inh_conv=M_inh_base(1:21);
M_inh_base(1,22:30)=zeros(1,9);
% put M_exc_base at the right place
M_inh(1,1:30)=M_inh_base;
M_inh=circshift(M_inh,[0 N+1-11]);
%M_inh=M_exc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Normalization mask %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M_normalization=zeros(1,3*N,K);
% coeff 1 at grid distance from the entry M+1,N+1 0,1, or 2
% if q==1 % grid distance
%     M_normalization(M:M+2,N:N+2,:)=ones(3,3,K);
%     M_normalization(M+1,N-1,:)=ones(1,1,K);
%     M_normalization(M+1,N+3,:)=ones(1,1,K);
%     M_normalization(M-1,N+1,:)=ones(1,1,K);
%     M_normalization(M+3,N+1,:)=ones(1,1,K);
%     den=13;
% else    % euclidian distance
%     M_normalization(M-1:M+3,N-1:N+3,:)=ones(5,5,K);
%     den=25;
% end    

% one dimensional normalization mask
M_normalization_base=[zeros(1,8),ones(1,5),zeros(1,17)];
M_normalization(1,1:30)=M_normalization_base;
M_normalization=circshift(M_normalization,[0 N+1-11]);
M_norm_conv=ones(1,5);
den=25;
inv_den=1/25;


% circshift_M_normalization=zeros(K,M,N,size(M_normalization,1),size(M_normalization,2));
% circshift_M_exc=zeros(K,M,N,size(M_exc,1),size(M_exc,2));
% circshift_M_inh=zeros(K,M,N,size(M_inh,1),size(M_inh,2));
% 
% for k=1:K
%     for i=1:M
%         for j=1:N
%             circshift_M_normalization(i,j,k,:,:)=circshift(M_normalization,[i-1,j-1,k-1]);
%             circshift_M_exc(i,j,k,:,:)=circshift(M_exc,[i-1,j-1,k-1]);
%             circshift_M_inh(i,j,k,:,:)=circshift(M_inh,[i-1,j-1,k-1]);
%         end
%     end
% end



       


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% the input image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nothing to do here
Iitheta=im;
% toroidal boundary condition
%   toroidal_Iitheta=repmat(Iitheta,3,3);
 
% mirrored boundary
toroidal_Iitheta=[fliplr(im),im,fliplr(im)];


newgx_toroidal_Iitheta=newgx(toroidal_Iitheta);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Nadal's diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

if nargout==3
   inh_energy=zeros(K,n_iter);
end   





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% the loop over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:(n_iter/curvdt)  % t gives the membrane time constant
%     disp(['Membrane time constant number ' int2str(ceil(t*curvdt)) ' of ' int2str(n_iter)])  
%     disp(['Iteration number ' int2str(t) ' of ' int2str(n_iter/curvdt)])  
    
%     if t>1
%        disp(['Loop duration ' int2str(loop_duration) ' seconds'])
%        disp(['Estimated remaining time ']) % int2str(remaining) ' seconds'])
%        disp(secs2hms(remaining))
%     end
    
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
   end            
       
   % time
%   tic

newgx_toroidal_x=newgx(toroidal_x);


x_int=zeros(M,N,K);
y_int=zeros(M,N,K);
I_norm=zeros(M,N,K);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%% excitation-inhibition %%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
   for k=1:K
                
%                 if t==1
%                    x_int(i,j,k)=sum(sum(sum(circshift_M_exc(i,j,k).*newgx_toroidal_Iitheta)));
%                    y_int(i,j,k)=sum(sum(sum(circshift_M_inh(i,j,k).*newgx_toroidal_Iitheta)));
%                 else
%                    x_int(i,j,k)=sum(sum(sum(circshift_M_exc(i,j,k).*newgx_toroidal_x)));
%                    y_int(i,j,k)=sum(sum(sum(circshift_M_inh(i,j,k).*newgx_toroidal_x)));
%                 end
%                 I_norm(i,j,k)=-2*(sum(sum(sum(circshift_M_normalization(i,j,k).*newgx_toroidal_x)))*inv_den);

%                 if t==1
%                    kk=convn(newgx_toroidal_Iitheta,M_exc_conv,'same');
%                    x_int(:,:,k)=kk(:,N+1:2*N);
%                    kk=convn(newgx_toroidal_Iitheta,M_inh_conv,'same');
%                    y_int(:,:,k)=kk(:,N+1:2*N);
%                 else
%                    kk=convn(newgx_toroidal_x,M_exc_conv,'same');
%                    x_int(:,:,k)=kk(:,N+1:2*N);
%                    kk=convn(newgx_toroidal_x,M_inh_conv,'same');
%                    y_int(:,:,k)=kk(:,N+1:2*N);
%                 end
%                 
%                 kk=convn(newgx_toroidal_x,M_norm_conv,'same');


                if t==1
                   kk=convolucio_optima(newgx_toroidal_Iitheta,M_exc_conv);
                   x_int(:,:,k)=kk(:,N+1:2*N);
                   kk=convolucio_optima(newgx_toroidal_Iitheta,M_inh_conv);
                   y_int(:,:,k)=kk(:,N+1:2*N);
                else
                   kk=convolucio_optima(newgx_toroidal_x,M_exc_conv);
                   x_int(:,:,k)=kk(:,N+1:2*N);
                   kk=convolucio_optima(newgx_toroidal_x,M_inh_conv);
                   y_int(:,:,k)=kk(:,N+1:2*N);
                end
                
                kk=convolucio_optima(newgx_toroidal_x,M_norm_conv);

              
               
               
               
               I_norm(:,:,k)=kk(:,N+1:2*N);
               I_norm(:,:,k)=-2*(I_norm(:,:,k).*inv_den).^r;
               
               % Sense normalitzacio
%                I_norm=0;


   %  the equations
    
%   for k=1:K
       
       
%        x_int=zeros(M,N,K);
%        y_int=zeros(M,N,K);
%        I_norm=zeros(M,N,K);
       
       
        
        % loops for the construction of the excitation and inhibition
        % terms and the normalization process
        % A=(i,j,k) is the reference entry (B=(ii,jj,kk))
		  
		  
		  
%		  for i=1:M
%            for j=1:N
                
                
                
                

                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%% normalization process %%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                

                
                % 13 is the number of grid points within an area of
                % diameter 2 for the grid distance
                %I_norm(i,j,k)=-2*(sum(sum(sum(circshift_M_normalization(i,j,k).*newgx_toroidal_x)))*inv_den);
 %           end
 %         end    
 %       I_norm(:,:,k)=I_norm(:,:,k)^r;
        
    % Iteration step (t -> t+1)
        if t==1
           x(:,:,k)=x(:,:,k)+curvdt*(-alphax*x(:,:,k)-newgy(y(:,:,k))+...
                             J0*newgx(Iitheta(:,:,k))+...
                             x_int(:,:,k)+...
                             Iitheta(:,:,k)+...                                     % the image
                             0.85*ones(M,N)+...
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
                             0.85*ones(M,N)+...
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
                             ones(M,N)+...     
                             0.1*(rand(M,N)-0.5)); 
        else    
           y(:,:,k)=y(:,:,k)+curvdt*(-alphay*y(:,:,k)+newgx(x(:,:,k))+...
                             y_int(:,:,k)+...
                             ones(M,N)+...     
                             0.1*(rand(M,N)-0.5));
        end
    
   end
   
   
    % Remember the values at any multiples of the membrane time constant
   if t*curvdt==ceil(t*curvdt)
      gx_final(:,:,:,t*curvdt)=newgx(x(:,:,:));
      gy_final(:,:,:,t*curvdt)=newgy(y(:,:,:));
   end
   
%   loop_duration=toc;
%   remaining=loop_duration*(n_iter/curvdt-t);
end


    

