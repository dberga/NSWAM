function [w c] = a_trous4(image, wlev)
% Implementation of Mallate Discrete Wavelet Transform.
%
% outputs:
%   w: cell array of length wlev, containing wavelet planes in 3
%   orientations.
%   c: cell array of length c, containing residual planes.
%
% inputs:
%   image: input image to be decomposed.
%   wlev: # of wavelet levels.

% pad image so that dimensions are powers of 2:
aux_image=image;
image = add_padding(image);

% Defined 1D Gabor-like filter:
h = [1./16.,1./4.,3./8.,1./4.,1./16.];
hd = [1./256.,1./16.,9./64.,1./16.,1./256.]./(70./256.);
hd1 = eye(5,5).*hd;
hd2 = fliplr(eye(5,5).*hd);

energy = sum(h);
inv_energy = 1/energy;
h = h*inv_energy;
w = cell(wlev,1);
c = cell(wlev,1);

% disp(strcat('Nombre plans wavelet a la funcio a_trous: ', num2str(wlev)));
for s = 1:wlev
    img_dim = size(image,1);
    orig_image = image;
    inv_sum = 1/sum(h);
    inv_sum_d = 1/sum(hd);
    
    
    
    prod = symmetric_filtering(image, h)*inv_sum;          % blur
    HF = prod;
	GF = image - prod;                              % horizontal frequency info                            
    
       
    prod = symmetric_filtering(HF, h')*inv_sum;            % blur
    HHF = prod;
    GHF = HF - prod;                                % vertical wavelet plane
   
    
     prod = symmetric_filtering(GF, h')*inv_sum;            % blur 
     HGF = prod;
     GGF = GF-prod;
     
     iD=orig_image - (HHF + HGF + GHF); 
     
       
     prod= symmetric_filtering(image, hd1)*inv_sum_d;
     SF=prod;
     PF=image-prod;
     
      
     prod= symmetric_filtering(SF, hd2)*inv_sum_d;
     SSF=prod;
     PSF=image-prod;
     
     
     prod = symmetric_filtering(PF, hd2)*inv_sum_d;            % blur 
     SPF = prod;
     PPF=PF-prod;
     
     %compute diag err
     err=iD-(SPF+PSF);
     unbalance=0.5;
     
    % Create and save wavelet plane:
%       DF = orig_image - (HGF + GF + GHF); 
%       DF1=PF;
%       DF2=PSF;
      w{s,1}(:,:,1) = HGF + (0.5.*err.*(1-unbalance));
      w{s,1}(:,:,2) = GHF + (0.5.*err.*(1-unbalance));
      w{s,1}(:,:,3) = SPF + (0.5.*err.*unbalance);
      w{s,1}(:,:,4) = PSF + (0.5.*err.*unbalance);
%       w{s,1}(:,:,1)=image -(symmetric_filtering(image, h)*inv_sum);
%       w{s,1}(:,:,2)=image -(symmetric_filtering(image, h')*inv_sum);
%       w{s,1}(:,:,3)=image -(symmetric_filtering(image, hd1)*inv_sum);
%       w{s,1}(:,:,4)=image -(symmetric_filtering(image, hd2)*inv_sum);
            
    % save residual
    C      = image - (w{s,1}(:,:,1)+w{s,1}(:,:,2)+w{s,1}(:,:,3)+w{s,1}(:,:,4));
    c{s,1} = C;
	 image=C;
	 
	% Upsample filter
	h = [0 upsample(h,2)];
    hd= upsample(hd,2);
    hd1 = [zeros(1,5*2^s+1); [zeros(5*2^s,1) eye(5*2^s,5*2^s).*hd]];
    hd2 = [zeros(1,5*2^s+1); [zeros(5*2^s,1) fliplr(eye(5*2^s,5*2^s).*hd)]];
% 	h = upsample(upsample(h,2)',2)';
   
    
end

%unpad wavelet plane and residual
for s=1:wlev
    for o=1:size(w{s,1},3)
        w2{s,1}(:,:,o)=erase_padding(w{s,1}(:,:,o),size(aux_image));
        c2{s,1} = erase_padding(c{s,1},size(aux_image));
    end
    w{s,1}=w2{s,1};
    c{s,1}=c2{s,1};
end

%debug
%close all
%for o=1:size(w{wlev-1,1},3)
%    figure,imagesc(w{wlev-1,1}(:,:,o));
%end

%close all
%for s=1:wlev
%    for o=1:size(w{s,1},3)
%        figure,imagesc(w{s,1}(:,:,o));
%    end
%end

end




