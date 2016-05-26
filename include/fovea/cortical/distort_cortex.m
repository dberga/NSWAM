function [ cortex ] = distort_cortex( image, ifix, jfix, cN, diag_visualAngle )

    [M,N,~] = size(image);
    diag_visualPixels = sqrt(M^2 + N^2);
    cortex_max_elong = 120;
    cortex_max_az = 60;
    

    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 5

        %lambda = 1.2;
        %e0= 1;
        cN = 1024;
        diag_visualAngle = pi;
    
       if nargin < 4
           ifix = round(M/2); %center
           jfix = round(N/2); %center
       end
    end
    
    cM = round((cortex_max_az/cortex_max_elong)*cN);

    %GET CORTEX FILS AND COLS PIXEL COORDS
    [cols_cortex,fils_cortex] = meshgrid(1:cN,1:cM);
    
    %CORTEX COORDS TO CORTEX PIXELS
    [cortex_X, cortex_Y] = cortexCoord2cortexPixel(fils_cortex, cols_cortex, cM,cN,cortex_max_elong,cortex_max_az);
     
     
    %CORTEX PIXELS TO VISUAL PIXELS
     [visual_X,visual_Y] = cortexPixel2visualPixel(cortex_X,cortex_Y);
        

    %VISUAL PIXELS TO VISUAL COORDS
     [fils_visual, cols_visual] = visualPixel2visualCoord(visual_X,visual_Y,jfix,ifix,diag_visualAngle,diag_visualPixels,M,N);
     
    %GET OUTPUT IMAGE
    cortex = insert_pixels(image,fils_visual,cols_visual,M,N,cM,cN);
     
  
end





function [cortex_X, cortex_Y] = cortexCoord2cortexPixel(cortex_fil,cortex_col,cM,cN, cortex_max_elong, cortex_max_az)



cortex_pix2elong = cortex_max_elong/cN;
cortex_pix2az = cortex_max_az/cM;

cortex_X = (cortex_col-1-(cN/2))*cortex_pix2elong;
cortex_Y = (cortex_fil-1-(cM/2))*cortex_pix2az;

end


function [visual_X,visual_Y] = cortexPixel2visualPixel(cortex_X,cortex_Y)



X = cortex_X;
Y = cortex_Y;

neg_X = find(X<0);
neg_Y = find(Y<0);

W = complex(abs(X),abs(Y));

lambda = 12; % mm
e0 = (1/180*pi);
% e0 = 1;

% Z = exp(W)-1;
Z = expm1(W/lambda)*e0;


i = imag(Z);
j = real(Z);

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);

visual_X = j;
visual_Y = i;


end



function [visual_fil, visual_col] = visualPixel2visualCoord(visual_X,visual_Y,fov_x,fov_y,diag_visualAngle,diag_visualPixels,M,N)



img_elong_angle = diag_visualAngle*N/diag_visualPixels;
img_az_angle = diag_visualAngle*M/diag_visualPixels;

eye_elong2pix = N/img_elong_angle;
eye_az2pix = M/img_az_angle;

visual_col = round(visual_X*eye_elong2pix+fov_x);
visual_fil = round(visual_Y*eye_az2pix+fov_y);

end

function [output_image] = insert_pixels(input_image,fils_in,cols_in,M_in,N_in,M_out,N_out)

    [~,~,C] = size(input_image);
    output_image = zeros(M_out,N_out,C);
    
    %fast, out of memory
%     fils_in = fils_in(fils_in > 0 & fils_in <= M_in);
%     cols_in = cols_in(cols_in > 0 & cols_in <= N_in);
%     output_image(fils_in,cols_in,:) = input_image(fils_in,cols_in,:);
    
    %slow, in memory
    for i=1:M_out
        for j=1:N_out
            if fils_in(i,j) > 0 && fils_in(i,j) <= M_in && cols_in(i,j) > 0 && cols_in(i,j) <= N_in
              output_image(i,j,:) = input_image(fils_in(i,j),cols_in(i,j),:);
            else
            end
        end
    end
    

end
