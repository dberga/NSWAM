function [ output_fovea ] = distort_foveal_magnification(  input_image , fixcoord_X, fixcoord_Y,e0, lambda, vAngle)

    
    
    [M,N,C] = size(input_image);
    
    %default parameters if not set
    if nargin < 4
        
       e0 = 1;
       vAngle = 20;
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
    
    %[mag_N,mag_M,~]=mag_coord(360, 360, e0, lambda);
    
    output_fovea = zeros(cM,cN,3);
    
    [A,B] = meshgrid(1:M,1:N);
    coords = [A(:) B(:)];
    coords_image_rows = coords(1:end,1);
    coords_image_cols = coords(1:end,2);
    
    
    [coords_fovea_cols,coords_fovea_rows] =Image2MFovea(coords_image_cols, coords_image_rows,M,N,fixcoord_X, fixcoord_Y, e0, lambda, vAngle);
    
    coords_fovea_cols = round(coords_fovea_cols);
    coords_fovea_rows = round(coords_fovea_rows);
    
    [coords_fovea_rows,coords_fovea_cols,coords_image_rows,coords_image_cols] = limit_coords_both(coords_fovea_rows,coords_fovea_cols,coords_image_rows,coords_image_cols,1,1,cM,cN);

    output_fovea = recoord(input_image,output_fovea, coords_image_rows,coords_image_cols, coords_fovea_rows, coords_fovea_cols);
    

    output_fovea = output_fovea/255;
end


