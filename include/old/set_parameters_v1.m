function [dedi]=set_parameters_v1(n,multires)



if n==0
    B=zeros(2,1,10);
    B(:,:,1)=[8;32];%[6;12];
    B(:,:,2)=[8;32];%[8;5];
    B(:,:,3)=[8;32];
    B(:,:,4)=[8;32];
    B(:,:,5)=[8;32];
    B(:,:,6)=[8;32];
    B(:,:,7)=[8;32];
    B(:,:,8)=[8;32];
    B(:,:,9)=[8;32];
    B(:,:,10)=[8;32];
%     B(:,:,1)=[60;80];
%     B(:,:,2)=0.8.*[80;60];
%     B(:,:,3)=[60;80];

    dedi=3.*B; 
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
    

