function [dedi]=set_parameters(n)



if n==1
    A=[60 70 85 100;
        60 60 60 60];
    A=[flipud(fliplr(A)),A(:,2:end)];
    sz=size(A,2);
    B=zeros(2,sz,sz,sz,3);
    for ii=1:sz
        for jj=1:sz
            for kk=1:sz
                B(:,ii,jj,kk,:)=[A(:,ii),A(:,jj),A(:,kk)];
            end
        end
    end    
    C=reshape(B,2,[],3);
    dedi=C;
elseif n==2
    B=zeros(2,6,3);
    B(:,:,1)=[60 70 70 70 85 60; 60 60 60 60 60 70];
    B(:,:,2)=[60 70 60 60 60 70;60 60 70 70 70 60];
    B(:,:,3)=[60 70 60 60 85 80;60 60 70 100 60 60];
    l=(0.2:0.1:1.5);ll=size(l,2);
    C=zeros(2,6*ll,3);
    for jj=1:ll
        C(:,1+6*(jj-1):6*jj,:)=l(jj).*B;
    end    
    C=floor(C); % bad names with comas... 
    dedi=C;
 elseif n==3  % mes petit que n==2
    B=zeros(2,6,3);
    B(:,:,1)=[60 70 70 70 85 60; 60 60 60 60 60 70];
    B(:,:,2)=[60 70 60 60 60 70;60 60 70 70 70 60];
    B(:,:,3)=[60 70 60 60 85 80;60 60 70 100 60 60];
    l=(0.05:0.025:0.1);ll=size(l,2);
    C=zeros(2,6*ll,3);
    for jj=1:ll
        C(:,1+6*(jj-1):6*jj,:)=l(jj).*B;
    end    
    C=floor(C); % bad names with comas... 
    dedi=C;   
elseif n==4
    B=zeros(2,1,3);
    B(:,:,1)=[60;150];
    B(:,:,2)=[60;120];
    B(:,:,3)=[60;140];
    l=[0.2:0.1:1.6];ll=size(l,2);
    C=zeros(2,ll,3);
    for jj=1:ll
        C(:,1+(jj-1):jj,:)=l(jj).*B;
    end    
    C=floor(C); % bad names with comas... 
    dedi=C; 
elseif n==0
    B=zeros(2,1,3);
    B(:,:,1)=[6;12];
    B(:,:,2)=[8;5];
    B(:,:,3)=[8;12];
%     B(:,:,1)=[60;80];
%     B(:,:,2)=0.8.*[80;60];
%     B(:,:,3)=[60;80];
    dedi=B; 
    
end    
    
    
    
    
end    
    
