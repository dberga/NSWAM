function [ image ] = undistort_cortex( cortex, ifix, jfix, M, N, diag_visualAngle )

    [cM,cN,~] = size(cortex);
    diag_visualPixels = sqrt(M^2 + N^2);
    cortex_max_elong = 120;
    cortex_max_az = 60;

    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 6

        %lambda = 1.2;
        %e0= 1;
        M = M/4;
        N = N/4;
        diag_visualAngle = pi/4;
    
       if nargin < 4
           ifix = round(M/2); %center
           jfix = round(N/2); %center
       end
    end
    

    %GET VISUAL FILS AND COLS PIXEL COORDS
    [cols_visual,fils_visual] = meshgrid(1:N,1:M);
    
    %VISUAL COORDS TO VISUAL PIXELS
    [visual_X, visual_Y] = visualCoord2visualPixel(cols_visual,fils_visual,jfix,ifix,diag_visualAngle,diag_visualPixels,M,N);
     
     
    %VISUAL PIXELS TO CORTEX PIXELS
     [cortex_X,cortex_Y] = visualPixel2cortexPixel(visual_X,visual_Y);
        

    %CORTEX PIXELS TO CORTEX COORDS
     [cols_cortex, fils_cortex ] = cortexPixel2cortexCoord(cortex_X,cortex_Y,cM,cN, cortex_max_elong, cortex_max_az);
     
    %GET OUTPUT IMAGE
    image = insert_pixels_2(cortex,fils_cortex,cols_cortex,cM,cN,M,N);
     
  
end




function [visual_X, visual_Y] = visualCoord2visualPixel(visual_col,visual_fil,fov_x,fov_y,diag_visualAngle,diag_visualPixels,M,N)
    
    img_elong_angle = diag_visualAngle*N/diag_visualPixels;
    img_az_angle = diag_visualAngle*M/diag_visualPixels;

    eye_elong2pix = N/img_elong_angle;
    eye_az2pix = M/img_az_angle;

visual_X = (visual_col-fov_x)/eye_elong2pix;
visual_Y = (visual_fil-fov_y)/eye_az2pix;

end

function [cortex_col, cortex_fil ] = cortexPixel2cortexCoord(cortex_X,cortex_Y,cM,cN, cortex_max_elong, cortex_max_az)

    cortex_pix2elong = cortex_max_elong/cN;
    cortex_pix2az = cortex_max_az/cM;

    cortex_col = round((cortex_X/cortex_pix2elong)+1+(cN/2));
    cortex_fil = round((cortex_Y/cortex_pix2az)+1+(cM/2));

end



function [cortex_X,cortex_Y] = visualPixel2cortexPixel(visual_X,visual_Y)


i = visual_Y;
j = visual_X;

neg_j = find(j<0);
neg_i = find(i<0);

Z = complex(abs(j),abs(i));

lambda = 12; % mm
e0 = (1/180*pi); % radians
% e0 = 1;

% W = log(Z+1);
W = lambda*log1p(Z/e0);


X = real(W);
Y = imag(W);

X(neg_j) = -X(neg_j);
Y(neg_i) = -Y(neg_i);

cortex_X = X;
cortex_Y = Y;


end


function [output_image] = insert_pixels_2(input_image,fils_in,cols_in,M_in,N_in,M_out,N_out)

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
