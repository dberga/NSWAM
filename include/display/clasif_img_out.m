function []=clasif_img_out(img,masc,channel,n_clus,fff)

n_ff=size(img,4);

alc=size(img,1);
ampl=size(img,2);

    feat=zeros(ampl*alc,n_ff);

	 mitja=mean(img(:,:,channel,fff),4);
	 
n_ff=0;
for ff=fff
    kk=( img(:,:,channel,ff)-mitja(:,:,channel) ).*double(masc(:,:,channel,ff));
    feat(:,ff)=kk(:);
	 n_ff=n_ff+1;
end

% feat(:,n_ff+1)=mitja(:);


n_clus_kmeans=0;

% while(n_clus_kmeans~=n_clus)
clasif=kmeans(feat,n_clus,'Start','sample','EmptyAction','drop','Replicates',5);
    
    n_clus_kmeans=max(clasif(:))-min(clasif(:))+1
% end


img_clasif=reshape(clasif,[alc ampl]);

figure,imagesc(img_clasif);

end