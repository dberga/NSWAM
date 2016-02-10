function [img]=IGaborTransform_XOP(coef,n_scales,Ls)

	disp('IGaborTransform_XOP...');

	img_act=coef{1}{1};
 	a=2;
 	M=a*4;
%  	a=1;
%  	M=4+(n_scales-2);
      
	for scale=n_scales:-1:2
		disp(['   scale: ' int2str(scale) ]);
 		L1=M*ceil(size(img_act,1)/M);
 		L2=M*ceil(size(img_act,2)/M);
%  		L1=size(img_act,1);
%  		L2=size(img_act,2);
		Ls1=Ls{scale}(1);
		Ls2=Ls{scale}(2);
		gd1=gabwin('dualgauss',a,M,L1);
		gd2=gabwin('dualgauss',a,M,L2);
		coef_gabor=zeros(M,size(img_act,1),M,size(img_act,2));
		coef_gabor(1,:,1,:)=img_act;
		index=1;
		for orient_1=1:M
			for orient_2=1:M
				if orient_1~=1 || orient_2~=1
					coef_gabor(orient_1,:,orient_2,:)=complex(coef{scale}{index},coef{scale}{index+1});
					index=index+2;
				end
			end
		end
		img_act = idgt2(coef_gabor,gd1,gd2,[a a],Ls{scale});
%		M=M-1;
	end

img=real(img_act);
      


% 	L1=size(img,1);
% 	L2=size(img,2);
% 	L=[L1 L2];
% 
% 	a_gabor=2;
% 	M_gabor=a_gabor*4;
% 
% 	img_act=img;
% 
% 	for scale=2:n_scales
% 
% 		g1=gabwin('gauss',a,M,L1);
% 		g2=gabwin('gauss',a,M,L2);
% 
% 		[coef_gabor,Ls{scale}] = dgt2(img,g1,g2,[a,a],[M,M],L);
% 		index=1;
% 		for orient_1=1:M_gabor
% 			for orient_2=1:M_gabor
% 				if orient_1~=1 || orient_2~=1
% 					gabor{scale}{index}=real(reshape(coef_gabor(orient_1,:,orient_2,:),size(coef_gabor,2),size(coef_gabor,4)));
% 					gabor{scale}{index+1}=imag(reshape(coef_gabor(orient_1,:,orient_2,:),size(coef_gabor,2),size(coef_gabor,4)));
% 					index=index+2;
% 				end
% 			end
% 		end
% 		img_act=reshape(coef_gabor(1,:,1,:),size(coef_gabor,2),size(coef_gabor,4));
% 		img_act_tmp{scale}=img_act;
% figure,imshow(img_act,[]);
% 	end
%       
% 	gabor{1}{1}=img_act;
% 
end