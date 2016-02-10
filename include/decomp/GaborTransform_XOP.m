function [coef,Ls]=GaborTransform_XOP(img,n_scales)


	disp('GaborTransform_XOP...');
	
 	a=2;
 	M=a*4;
% 	a=1;
% 	M=4;

	img_act=img;

	for scale=2:n_scales
		disp(['   scale: ' int2str(scale)]);

		L1=M*ceil(size(img_act,1)/M);
		L2=M*ceil(size(img_act,2)/M);
%		L2=size(img_act,2);
		L=[L1 L2];
		g1=gabwin('gauss',a,M,L1);
		g2=gabwin('gauss',a,M,L2);

		[coef_gabor,Ls{scale}] = dgt2(img_act,g1,g2,[a,a],[M,M],L);
		index=1;
		figure;
		for orient_1=1:M
			for orient_2=1:M
				if orient_1~=1 || orient_2~=1
					coef{scale}{index}=real(reshape(coef_gabor(orient_1,:,orient_2,:),size(coef_gabor,2),size(coef_gabor,4)));
					coef{scale}{index+1}=imag(reshape(coef_gabor(orient_1,:,orient_2,:),size(coef_gabor,2),size(coef_gabor,4)));
					index=index+2;
%			 figure,imagesc(abs(reshape(coef_gabor(orient_1,:,orient_2,:),size(coef_gabor,2),size(coef_gabor,4))));colormap(gray);
				end
         subplot(M,M,(orient_1-1)*M+orient_2),subimage(reshape(abs(coef_gabor(orient_1,:,orient_2,:))./255,size(abs(coef_gabor(orient_1,:,orient_2,:)),2),size(abs(coef_gabor(orient_1,:,orient_2,:)),4)))
			end
		end
		img_act=reshape(coef_gabor(1,:,1,:),size(coef_gabor,2),size(coef_gabor,4));
%		img_act_tmp{scale}=img_act;
%		M=M+1;

	end
      
	coef{1}{1}=real(img_act);
figure,imshow(coef{1}{1},[]);

end