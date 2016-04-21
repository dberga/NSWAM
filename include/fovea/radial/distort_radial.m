function [output_image] = distort_radial(input_image, cx, cy, vAngle, L, p1, p2, p3, p4, p5)

    [nrows,ncols] = size(input_image);
    [xi,yi] = meshgrid(1:ncols,1:nrows);
    XY = [xi.' yi.'];
    
     if nargin < 4
            vAngle = 25; %angle of view, fov experiment (usually from 21 to 28)
            %do stuff with angle to get L, p1, p2, p3, p4, p5;
            L=nrows;
            p1 = 0;
            p2 = 1;
            p3 = .5;
            p4 = 0;
            p5 = 0;
            
       if nargin < 2
            cx = round(ncols/2); %xcenter
            cy = round(nrows/2); %ycenter
       end    
    end
    t.tdata(1)= cx ; %cx
    t.tdata(2)= cy ; %cx 
    t.tdata(3)= L; %scaling factor
    t.tdata(4)= p1;%p1
    t.tdata(5)= p2;%p2
    t.tdata(6)= p3;%p3
    t.tdata(7)= p4;%p4
    t.tdata(8)= p5;%p5
    han=@radial;
    %options = [128 128 128 0 1 .5 0 0];
    options = [t.tdata(1) t.tdata(2) t.tdata(3) t.tdata(4) t.tdata(5) t.tdata(6) t.tdata(7) t.tdata(8)];
    %han = radial(XY,t);
    Tmatrix=maketform('custom',2,2,[],han, options);
    
    output_image=imtransform(input_image,Tmatrix);

end
