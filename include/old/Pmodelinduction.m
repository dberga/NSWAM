function [gx_final,gy_final] = Pmodelinduction(im,curvdt,n_iter)


% Modified in October, 2010 (Euler's method implemented)
% From RZLimodel: "This is a new version where Euler's integration method is used. A
% distinction is done between the membrane time constant tau=1 and the
% integration time constant curvdt. We store the values at every multiple
% of the time membrane constant, i.e. every tau/curvdt=1/curvdt iterations
% of the system."

% Created in May 2010 (cf. Matlab/ZLi/ZLinduction)

% parameters
alpha_x=1;
alpha_y=1;



[M,N]=size(im);
x=zeros(1,N);
y=zeros(1,N);
gx_final=zeros(M,N,n_iter);
gy_final=zeros(M,N,n_iter);

Ii=im; 

% initialization of the activity levels
x=newgx(im);

% visual input

% generate masks
diam=5;
mask_exc=zeros(1,2*diam+1);
mask_inh=zeros(1,2*diam+1);
for k=-diam:diam
    mask_exc(k+diam+1)=Jexc_ind(k);
    mask_inh(k+diam+1)=Winh_ind(k);
end    
mask_exc(diam+1)=0; % self-excitation is defined directly below (0.8)
mask_inh(diam+1)=0;
% adapt the masks to the toroidal representation
mask_exc=[zeros(1,N-diam),mask_exc,zeros(1,2*N-diam-1)];
mask_inh=[zeros(1,N-diam),mask_inh,zeros(1,2*N-diam-1)];


% time iterations
for t=1:(n_iter/curvdt)  % t gives the membrane time constant
%    disp(['Membrane time constant number ' int2str(ceil(t*curvdt)) ' of ' int2str(n_iter)])  ;
%    disp(['Iteration number ' int2str(t) ' of ' int2str(n_iter/curvdt)])  ;
    
    if t>1
%       disp(['Loop duration ' int2str(loop_duration) ' seconds']);
%       disp(['Estimated remaining time ']); % int2str(remaining) ' seconds'])
%       disp(secs2hms(remaining));
    end
    % toroidal boundary condition 
%     toroidal_x=repmat(x,1,3); 
%     toroidal_y=repmat(y,1,3);

    % other condition
      x1=x(1);xN=x(N);
      y1=y(1);yN=y(N);
      toroidal_x=[x1*ones(1,N),x,xN*ones(1,N)];
      toroidal_y=[y1*ones(1,N),y,yN*ones(1,N)];
    
    % time
    tic;
    
    
%     for i=1:N
%         
%         
%         
%         x(i)=x(i)+curvdt*(-alpha_x*x(i)+0.8*x(i)+...
%             sum(mask_exc.*toroidal_x)-...
%             (0.8*toroidal_y(N+i-1)+toroidal_y(N+i)+0.8*toroidal_y(N+i+1))+...
%             Ii(i)+...
%             0.85+...
%             0);        % normalization
%                      %noise 
%         y(i)=y(i)+curvdt*(-alpha_y*y(i)+newgx(x(i))+...
%             sum(mask_inh.*toroidal_x)+...
%             1);
%         
% 	 end
% 	 
		rang=1:numel(x);
        x=x+curvdt.*(-alpha_x.*x+0.8*x+...
             sum(mask_exc.*toroidal_x)-...
             (0.8*toroidal_y(rang+(N-1))+toroidal_y(rang+(N))+0.8.*toroidal_y(rang+(N+1)))+...
             Ii+...
             0.85+...
             0);        % normalization
			 
	         y=y+curvdt.*(-alpha_y.*y+newgx(x)+...
            sum(mask_inh.*toroidal_x)+...
            1);

  % Save the values at any multiples of the membrane time constant
   if t*curvdt==ceil(t*curvdt)
      gx_final(:,:,t*curvdt)=x; %newgx(x(:,:,:));
      gy_final(:,:,t*curvdt)=y; %newgy(y(:,:,:));
   end
   
   loop_duration=toc;
   remaining=loop_duration*(n_iter/curvdt-t);
end    
    


