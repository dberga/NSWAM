function [dedi]=set_parameters_v2(n,multires)

% note dedi is 2 x number of scale x number of different parameters you
% want to use; if you want all the scale to have the same de and di, in
% that case the second dimension of dedi is 1

if n==0
    
     B=zeros(2,10,8);
     %B=rand(2,10,8);
     k=zeros(1,1,8);k(1,1,1:8)=(1:8);
    a=repmat(k,[2,10,1]);
    B=rand(2,10,8).*a;
%     B(:,1,:)=[8;32];%[6;12];
%     B(:,2,:)=[8;32];%[8;5];
%     B(:,3,:)=[8;32];
%     B(:,4,:)=[8;32];
%     B(:,5,:)=[8;32];
%     B(:,6,:)=[8;32];
%     B(:,7,:)=[8;32];
%     B(:,8,:)=[8;32];
%     B(:,9,:)=[8;32];
%     B(:,10,:)=[8;32];
%     B(:,:,1)=[60;80];
%     B(:,:,2)=0.8.*[80;60];
%     B(:,:,3)=[60;80];

    dedi=3.*B; 
elseif n==2000 % Parametres amb nova estructura de dades plans wavelet
%     A=[2 2 2 2 2 2 2 2 2;...
%         6 6 6 6 6 6 6 6 6 ];
    A=[28.2322    6.7710   41.2525   47.2836...
        39.9862    5.6558   42.8411    5.7425    9.0300;...
        29.6037   36.9076   14.6223    8.4204...
        30.0576   20.8750   11.9750   37.3185    8.7982];
    dedi=A;
elseif n==1000
    A=[48.4694   28.2322    6.7710   41.2525   47.2836...
        39.9862    5.6558   42.8411    5.7425    9.0300;...
        39.2316   29.6037   36.9076   14.6223    8.4204...
        30.0576   20.8750   11.9750   37.3185    8.7982];
    dedi=A;
elseif n==1001
    A=[48.4694   28.2322    26.7710   41.2525   47.2836...
        39.9862    5.6558   42.8411    5.7425    9.0300;...
        39.2316   29.6037   36.9076   14.6223    8.4204...
        30.0576   20.8750   11.9750   37.3185    8.7982];
    dedi=A;  
elseif n==1002
    A=[48.4694   28.2322    36.7710   41.2525   47.2836...
        39.9862    5.6558   42.8411    5.7425    9.0300;...
        39.2316   29.6037   36.9076   14.6223    8.4204...
        30.0576   20.8750   11.9750   37.3185    8.7982];
    dedi=A;     
elseif n==1
	sigma_de=1;
	sigma_di=9;
    B=zeros(2,1,10);
	 switch (multires)
		 case 'a_trous'
			for i=1:10
				 B(:,:,i)=[sigma_de*sigma_de*2^((i-2)*2);sigma_di*sigma_di*2^((i-2)*2)];
			end
		 otherwise
			for i=1:10
				B(:,:,i)=[sigma_de*sigma_de;sigma_di*sigma_di];
			end
	 end
%     B(:,:,1)=[sigma_de*sigma_de;sigma_di*sigma_di];%[6;12];
%     B(:,:,2)=[sigma_de*sigma_de;sigma_di*sigma_di];%[8;5];
%     B(:,:,3)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,4)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,5)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,6)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,7)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,8)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,9)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,10)=[sigma_de*sigma_de;sigma_di*sigma_di];
%     B(:,:,1)=[60;80];
%     B(:,:,2)=0.8.*[80;60];
%     B(:,:,3)=[60;80];
    dedi=B; 
    
end    
    
end    
    

