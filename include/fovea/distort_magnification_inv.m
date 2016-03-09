function [ output_image ] = distort_magnification_inv(  input_cortex , fixcoord_X, fixcoord_Y,e0, lambda, vAngle)

    
    
    [cM,cN,C] = size(input_cortex);


    %default parameters if not set
    if nargin < 4
        
       e0 = 1;
       vAngle = 25;
       M = cM;
       N = cN;
       lambda_N = cN / log(1+(360+e0));
       lambda_M = cM*180*(360+e0) / (360*360*pi);
       lambda = max([lambda_N lambda_M]);
       
       if nargin < 2
           fixcoord_X = round(N/2); %center
           fixcoord_Y = round(M/2); %center
       end
       
    end
    
    
    %[mag_N,mag_M,~]=mag_coord(360, 360, e0, lambda);
    
    output_image = zeros(M,N);
    
    
    [A,B] = meshgrid(1:cM,1:cN);
    coords = [A(:) B(:)];
    coords_cortex_rows = coords(1:end,1);
    coords_cortex_cols = coords(1:end,2);
    
    
    [coords_image_rows,coords_image_cols] =Cortex2Image(coords_cortex_rows,coords_cortex_cols,M,N,fixcoord_X, fixcoord_Y, e0, lambda, vAngle);
    
    coords_image_cols = round(coords_image_cols);
    coords_image_rows = round(coords_image_rows);
    
    [coords_image_rows,coords_image_cols] = limit_coords(coords_image_rows,coords_image_cols,1,1,M,N);
    
    output_image(coords_image_rows,coords_image_cols) = input_cortex(coords_cortex_rows,coords_cortex_cols);
    


    output_image = output_image/255;
end

              

%     max_r = sqrt(M^2 + N^2);
%     max_rho = (360*max_r)/vAngle;
%     max_theta = 2*pi; %X maxim = recta cap a la dreta en polar
%     [max_N,~] = pol2cart(max_theta,max_rho);
%     max_theta = pi*0.5; %Y maxim = recta cap amunt en polar
%     [~,max_M] = pol2cart(max_theta,max_rho);
%     max_M = max_M*2;
%     max_N = max_N*2;
%     input_image2 = imresize(input_image,[max_M max_N]);
% 
%     xcenter = round((fixcoord_X/N)*max_N);
%     ycenter = round((fixcoord_Y/M)*max_M);	
%     [ e_center, theta_center] = get_coord_props( 0,0,xcenter,ycenter,M,N,vAngle );
%     [Xcenter,Ycenter,~] = mag_coord(e_center, theta_center, e0, lambda);
