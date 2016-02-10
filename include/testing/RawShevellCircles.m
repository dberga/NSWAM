% Generation of Shevell circles
% 
% PARAMETERS:
%   size: image size (it is a square image), in pixels.
%   inductor: lsY color LUT value of immediate inductor circle
%   inductor_far: lsY color LUT value of far inductor circle
%   test_thickness: thicknes of test ring relative to thicknes of 
%   inductor rings. Equal width for all rings is test_thickness=1
%   
%   outpic =RawShevellCircles(size,inductor,inductor_far,test,test_thickness)

function outpic = RawShevellCircles(size,inductor,inductor_far,test,test_thickness,n_rings)

    width=size;
    height=width;
    % -------------------------------------------------------------------------
    outpic=ones(height, width);

if nargin < 6
    circle_size_pix=width;
    circle_size_deg=6.2;
    internal_circle_size_deg=1.1;

    % Rings far inductor
    inner_radius_bkg=internal_circle_size_deg/2./circle_size_deg*circle_size_pix;
    outer_radius_bkg=circle_size_deg/2./circle_size_deg*circle_size_pix;
    outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius_bkg, outer_radius_bkg, inductor_far);

    rings=(circle_size_deg-internal_circle_size_deg)*0.5/(9./60.)-1;
    

    % Rings immediate inductor
    for i=1:2:rings
        inner_radius=inner_radius_bkg+9./60.*i/circle_size_deg*circle_size_pix;
        outer_radius=inner_radius+9./60./circle_size_deg*circle_size_pix;

        outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius, outer_radius, inductor);
    end

    % Anillo test
    inner_radius=inner_radius_bkg+9./60.*rings/2./circle_size_deg*circle_size_pix;
    outer_radius=inner_radius+9./60.*test_thickness/circle_size_deg*circle_size_pix;

    outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius, outer_radius, test);
else
    %variable ring sizes and
    
    circle_size_pix=width;
    circle_size_deg=6.2;
    internal_circle_size_deg=1.1;

    % Rings far inductor
    inner_radius_bkg=internal_circle_size_deg/2./circle_size_deg*circle_size_pix;
    outer_radius_bkg=circle_size_deg/2./circle_size_deg*circle_size_pix;
    outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius_bkg, outer_radius_bkg, inductor_far);

    %(circle_size_deg-internal_circle_size_deg)*0.5/(9./60.)-1;
    rings = round(n_rings);
    if rings < 3
        error('too few rings');
    elseif rings >= (size/4)
        error('too many rings');
    end
    
    % Rings immediate inductor
    for i=1:2:rings-1
%         inner_radius=inner_radius_bkg+9./60.*i/circle_size_deg*circle_size_pix;
%         outer_radius=inner_radius+9./60./circle_size_deg*circle_size_pix;
        inner_radius = (outer_radius_bkg - inner_radius_bkg)./rings .*i + inner_radius_bkg ;
        outer_radius = (outer_radius_bkg - inner_radius_bkg)./rings .*(i+1)+ inner_radius_bkg ;
        
        outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius, outer_radius, inductor);
    end
%     Anillo test
%     inner_radius=inner_radius_bkg+9./60.*rings/2./circle_size_deg*circle_size_pix;
%     outer_radius=inner_radius+9./60.*test_thickness/circle_size_deg*circle_size_pix;
      reg_ring_width = (outer_radius_bkg - inner_radius_bkg)./rings;
      test_ring_width = test_thickness * reg_ring_width;         
      pos = (round(rings.*0.5)); pos = pos - rem(pos,2);
      
      inner_radius = reg_ring_width .* pos + inner_radius_bkg + 0.5*(reg_ring_width - test_ring_width);
      outer_radius = reg_ring_width .* (pos) + inner_radius_bkg + 0.5*(reg_ring_width + test_ring_width);
      outpic=DrawRing(outpic, 0.5*width, 0.5*height, inner_radius, outer_radius, test);
end
