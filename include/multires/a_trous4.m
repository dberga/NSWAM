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

%normalize filter by energy
energy = sum(h);
inv_energy = 1/energy;
h = h*inv_energy;

energy_d = sum(hd);
inv_energy_d = 1/energy_d;
hd = hd*inv_energy_d;
hd1 = hd1*inv_energy_d;
hd2 = hd1*inv_energy_d;

w = cell(wlev,1);
c = cell(wlev,1);

% disp(strcat('Nombre plans wavelet a la funcio a_trous: ', num2str(wlev)));
for s = 1:wlev
    img_dim = size(image,1);
    orig_image = image;
    inv_sum = 1/sum(h);
    inv_sum_d = 1/sum(hd);
    
    %compute horizontal filter
    prod = symmetric_filtering(image, h)*inv_sum;          % blur
    HF = prod;
	GF = image - prod;                              % horizontal frequency info                            
    
    %compute vertical filter
    prod = symmetric_filtering(HF, h')*inv_sum;            % blur
    HHF = prod;
    GHF = HF - prod;                                % vertical wavelet plane
   
    %compute vertical filter over horizontal plane
     prod = symmetric_filtering(GF, h')*inv_sum;            % blur 
     HGF = prod;
     GGF = GF-prod;
     
     %compute crossed diff
     iD=orig_image - (HHF + HGF + GHF); 
     
     %compute diagonal1 filter
     prod= symmetric_filtering(image, hd1)*inv_sum_d;
     SF=prod;
     PF=image-prod;
     
     %compute diagonal2 filter
     prod= symmetric_filtering(SF, hd2)*inv_sum_d;
     SSF=prod;
     PSF=image-prod;
     
     %compute diagonal2 filter over diagonal1 plane
     prod = symmetric_filtering(PF, hd2)*inv_sum_d;            % blur 
     SPF = prod;
     PPF=PF-prod;
     
     %compute diagonals err diff with crossed
     err=iD-(SPF+PSF);
     unbalance=0.5;
     
    % DF = orig_image - (HGF + GF + GHF); %crossed horizontal and
    
    % Create and save wavelet plane:
      w{s,1}(:,:,1) = HGF + (0.5.*err.*(1-unbalance)); %v
      w{s,1}(:,:,2) = GHF + (0.5.*err.*(1-unbalance)); %h
      w{s,1}(:,:,3) = SPF + (0.5.*err.*unbalance); %d1
      w{s,1}(:,:,4) = PSF + (0.5.*err.*unbalance); %d2
            
    % save residual
    C      = image - (w{s,1}(:,:,1)+w{s,1}(:,:,2)+w{s,1}(:,:,3)+w{s,1}(:,:,4));
    c{s,1} = C;
	 image=C;
	 
	% Upsample filter
	h = [0 upsample(h,2)];
    hd= upsample(hd,2);
    hd1 = [zeros(1,5*2^s+1); [zeros(5*2^s,1) eye(5*2^s,5*2^s).*hd]];
    hd2 = [zeros(1,5*2^s+1); [zeros(5*2^s,1) fliplr(eye(5*2^s,5*2^s).*hd)]];
   
    
end

%unpad wavelet plane and residual
[w,c]=erase_padding_w(w,c,wlev,size(aux_image));

%% debug
% close all
% for s=1:wlev
%    for o=1:size(w{s,1},3)
%        figure,imagesc(w{s,1}(:,:,o));
%    end
% end

end




