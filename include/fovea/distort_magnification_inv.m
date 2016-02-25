function [ output_image ] = distort_magnification_inv(  input_image , fixcoord_X, fixcoord_Y,e0, lambda, vAngle)

    
    
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


    max_r = sqrt(M^2 + N^2);
    max_rho = (360*max_r)/vAngle;
    max_theta = 2*pi; %X maxim = recta cap a la dreta en polar
    [max_N,~] = pol2cart(max_theta,max_rho);
    max_theta = pi*0.5; %Y maxim = recta cap amunt en polar
    [~,max_M] = pol2cart(max_theta,max_rho);
    max_M = max_M*2;
    max_N = max_N*2;
    input_image2 = imresize(input_image,[max_M max_N]);

    Xcenter = round((fixcoord_X/N)*mag_N);
    Ycenter = round((fixcoord_Y/M)*mag_M);	

    for c=1:C %channel
        for Y=1:mag_M %coord Y
            for X=1:mag_N %coord X

           	%X2 = Xcenter - X; X = X2;
           	%Y2 = Ycenter - Y; Y = Y2;
                [e,azimuth] = mag_coord_inv(X, Y, e0, lambda);
		
                [ x, y] = get_coord_props_inv( e,azimuth,fixcoord_X,fixcoord_Y,M,N,max_M,max_N,vAngle );
                
                x = round(x)+1;
                y = round(y)+1;


		output_image(Y,X,c)= input_image2(y,x,c);
		

		
                
                
              
                end
        end
        
       
    end
    output_image = imresize(output_image,[M N]);

          
    
    
    output_image = output_image/255;
end

              

