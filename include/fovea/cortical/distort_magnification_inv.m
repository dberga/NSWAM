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
    
    output_image = zeros(M,N,3);
    
    
    [A,B] = meshgrid(1:cM,1:cN);
    coords = [A(:) B(:)];
    coords_cortex_rows = coords(1:end,1);
    coords_cortex_cols = coords(1:end,2);
    
    
    [coords_image_cols,coords_image_rows] =Cortex2Image(coords_cortex_cols,coords_cortex_rows,M,N,fixcoord_X,fixcoord_Y, e0, lambda, vAngle);
    
    coords_image_cols = round(coords_image_cols);
    coords_image_rows = round(coords_image_rows);
    
    [coords_image_rows,coords_image_cols,coords_cortex_rows,coords_cortex_cols] = limit_coords_both(coords_image_rows,coords_image_cols,coords_cortex_rows,coords_cortex_cols,1,1,cM,cN);
    
    output_image = recoord(input_cortex,output_image,coords_cortex_rows,coords_cortex_cols, coords_image_rows, coords_image_cols);


    output_image = output_image/255;
end

              
