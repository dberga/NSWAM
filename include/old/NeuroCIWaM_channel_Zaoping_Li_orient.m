function [curv_final,iFactor] = NeuroCIWaM_channel_Zaoping_Li_orient(param)


curv=param.curv;
niter=param.niter;
prec=param.prec;
scale=param.scale;
de=param.de;
di=param.di;
%multires=param.multires;
factor_normal=param.normal_input;
ON_OFF=param.ON_OFF;
genpar=param.genpar;


n_orient=size(curv,2);
disp([ ' n_orient: ' int2str(n_orient)])

curv_final=curv;
iFactor=curv_final;
  

    for orient=1:n_orient
%figure,imshow(curv{orient},[]);
%       n_lines=size(curv{scale}{orient},1);
%		disp([ ' orient: ' int2str(orient) ' n_lines: ' int2str(n_lines)]);

		disp([ ' orient: ' int2str(orient) ' size: ' int2str(size(curv{orient}))]);

      
      disp(['   curv min,max:' num2str(min(min(curv{orient},[],1),[],2)) ',' num2str(max(max(curv{orient},[],1),[],2))]);
      
      
 
         % Processat per separat de valors positius i negatius

         % Sequencial
		index_negatius = find(curv{orient}<0);
      index_positius = find(curv{orient}>0);

		
		switch(ON_OFF)
			
			case 0 % Separat
				positius = curv{orient};
				negatius = -curv{orient};
				positius(index_negatius)=0;
				negatius(index_positius)=0;

					% positius

				kk=Zaoping_Li(positius, factor_normal, prec,niter,de,di,genpar,scale);
				iFactor{orient}(index_positius)=kk(index_positius);

		% 		if(kk<0)
		% 			disp(['Problema positius!']);
		% 		end

					% negatius

				kk=Zaoping_Li(negatius, factor_normal, prec,niter,de,di,genpar,scale);
				iFactor{orient}(index_negatius)=kk(index_negatius);

			case 1 % Abs
				dades=curv{orient};
				dades(index_negatius)=-dades(index_negatius);				
				iFactor{orient}=Zaoping_Li(dades, factor_normal, prec,niter,de,di,genpar,scale);

			case 2 % Square
				dades=curv{orient}.*curv{orient};				
				iFactor{orient}=Zaoping_Li(dades, factor_normal, prec,niter,de,di,genpar,scale);
				
		end
		
		curv_final{orient}=curv{orient}.*iFactor{orient};
		

% 		figure,imagesc(iFactor{orient}); colormap('gray');
% 		figure,imagesc(curv{orient}); colormap('gray');
% 		figure,imagesc(curv_final{orient}); colormap('gray');

%figure,imagesc([curv{orient} iFactor{orient} curv_final{orient}]); colormap('gray');
figure;
subplot(1,3,1),imagesc(curv{orient});colormap('gray');
subplot(1,3,2),imagesc(iFactor{orient},[0 1]); colormap('gray');
subplot(1,3,3),imagesc(curv_final{orient});colormap('gray');
%ginput(1);
		
      
%        index_negatius = find(curv{scale}{orient}<0);
%        
%       curv{scale}{orient}(index_negatius)=-1*curv{scale}{orient}(index_negatius);
%       
%       [gx_final,gy_final] = Qmodelinduction_v3_5(curv{scale}{orient},prec,niter,2,'mirror',de,di);
%      
%       gx_final(index_negatius)=-1*gx_final(index_negatius);
%       
%       			%	Mean
%       kk=mean(gx_final(:,:,:,1:niter),4);
%       curv_final{scale}{orient}=kk;

      
      
      disp(['   kk min,max:' num2str(min(min(curv_final{orient},[],1),[],2)) ',' num2str(max(max(curv_final{orient},[],1),[],2))]);

%if isnan(min(min(curv_final{orient},[],1),[],2))
%   curv_final{orient}=0;
%end

%         figure,imshow(iFactor{orient},[]);
%         figure,imshow([curv{orient} iFactor{orient}],[]);


%      if(scale==n_scales && orient==n_orient)
%         figure,imshow(kk,[]);
%      end

      
%       if(OrientAngle(orient,n_orient)==0)
%          n_lines=size(curv{scale}{orient},1);
%       else
%          n_lines=size(curv{scale}{orient},2);
%       end
%		disp([ ' orient: ' int2str(orient) ' n_lines: ' int2str(n_lines)]);
%       for lin=1:n_lines
%          
%          if(OrientAngle(orient,n_orient)==0)
%             line=curv{scale}{orient}(lin,:);
%          else
%             line=curv{scale}{orient}(:,lin)';
%          end
% %			[gx_final,gy_final] = Pmodelinduction(line,prec,niter);
% 
% %			[gx_final,gy_final] = Qmodelinduction_v3(line,prec,niter,2,'mirror',de,di);
% 			[gx_final,gy_final] = Qmodelinduction_v3_4(line,prec,niter,2,'mirror',de,di);
% 
% 
% 			
% 			%	Last iter
% %			curv_final{scale}{orient}(lin,:)=gx_final(1,:,1,20);
% 
% 			%	Mean
% 			kk=mean(gx_final(1,:,1,1:10),4);
%          if(OrientAngle(orient,n_orient)==0)
%             curv_final{scale}{orient}(lin,:)=kk;
%          else
%             curv_final{scale}{orient}(:,lin)=kk';
%          end
% 
% 			%	Max
% %			[kk,index_max]=max(abs(gx_final(1,:,1,:)),[],4);
% %			curv_final{scale}{orient}(lin,:)=gx_final(index_max);
% 		end
		
    end
   
    
%	curv_final=curv;


end