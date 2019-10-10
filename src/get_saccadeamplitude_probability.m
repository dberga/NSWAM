function [ PSA ] = get_saccadeamplitude_function( SA ) %, task
    %if nargin < 2, task = 'fv'; end

    %% curve from (fig 1): Tatler, Baddeley, Vincent, 2005
    %SA_instances=[0-2, 2-4, 4-6, 6-8, 8-10, 10-12, 12-14, 14-16, 16-18, 18-20, 20+];
    PSA_fv=[.15, .20, .17, .15, .12, .08, .06, .04, .03, .02, .03];
    
    %% interpolate to augment probability vector
    init_func=0;
    end_func=20;
    precision=0.25;
    PSA_fv=interp1(init_func:2:end_func,PSA_fv,init_func:precision:end_func);
    
    %% find P manually
    %for i=init_func:precision:end_func
    %   if SA >= i && SA < i+precision
    %      PSA=PSA_fv(i);
    %   end
    %end
    
    %% find P numerically
    i=init_func:precision:end_func;
    if numel(SA)==1
    [ d, ix ] = min( abs( i-SA ) );
    PSA=PSA_fv(ix);
    else
       for y=1:size(SA,1) 
           for x=1:size(SA,2) 
               [ d, ix ] = min( abs( i-SA(y,x) ) );
                PSA(y,x)=PSA_fv(ix);
           end
       end
    end
    
end
