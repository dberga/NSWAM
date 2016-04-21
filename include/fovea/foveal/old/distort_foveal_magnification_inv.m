function [ output_image ] = distort_foveal_magnification_inv(  input_fovea , fixcoord_X, fixcoord_Y,e0, lambda, vAngle)

    
    
    [cM,cN,C] = size(input_fovea);


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
    coords_fovea_rows = coords(1:end,1);
    coords_fovea_cols = coords(1:end,2);
    
    
    [coords_image_cols,coords_image_rows] =MFovea2Image(coords_fovea_cols,coords_fovea_rows,M,N,fixcoord_X,fixcoord_Y, e0, lambda, vAngle);
    
    coords_image_cols = round(coords_image_cols);
    coords_image_rows = round(coords_image_rows);
    
    [coords_image_rows,coords_image_cols,coords_fovea_rows,coords_fovea_cols] = limit_coords_both(coords_image_rows,coords_image_cols,coords_fovea_rows,coords_fovea_cols,1,1,cM,cN);
    
    output_image = recoord(input_fovea,output_image,coords_fovea_rows,coords_fovea_cols, coords_image_rows, coords_image_cols);


    output_image = output_image/255;
end

              
