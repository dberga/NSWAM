function [ output_image ] = distort_magnification(  input_image , fixcoord_X, fixcoord_Y,e0, lambda, vAngle)

    
    
    [M,N,C] = size(input_image);
    
    %default parameters if not set
    if nargin < 4
        
       e0 = 1;
       vAngle = 25;
       cM = M;
       cN = N;
       lambda_N = cN / log(1+(360+e0));
       lambda_M = cM*180*(360+e0) / (360*360*pi);
       lambda = max([lambda_N lambda_M]);
       
       if nargin < 2
           fixcoord_X = round(N/2); %center
           fixcoord_Y = round(M/2); %center
       end
       
    end
    
    
    [mag_N,mag_M,~]=mag_coord(360, 360, e0, lambda);
    output_image = zeros(round(mag_M),round(mag_N));

    
    for c=1:C %channel
        for y=1:M %coord Y
            
            for x=1:N %coord X
           
                
                [ e, theta] = get_coord_props( x,y,fixcoord_X,fixcoord_Y,M,N,vAngle );
                [X,Y,~] = mag_coord(e, theta, e0, lambda);
                
                
                X = round(X)+1;
                Y = round(Y)+1;
                output_image(Y,X,c) = input_image(y,x,c);

                
              
                end
        end
        
       
    end
    
    
    output_image = output_image/255;
end

              

