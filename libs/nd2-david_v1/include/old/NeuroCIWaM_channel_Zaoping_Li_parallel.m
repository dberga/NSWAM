function [gx_final,gy_final,inh_energy] = NeuroCIWaM_channel_Zaoping_Li_parallel(param, parallel)


curv=param.curv;



for scale=2:n_scales
	n_orient=size(curv{scale},2);
	disp(['scale: ' int2str(scale) ' n_orient: ' int2str(n_orient)])
	
    
    
    param.curv=curv{scale};
    
    
    NeuroCIWaM_channel_Zaoping_Li_parallel(param, parallel);
    
    
    
    
    for orient=1:n_orient
%figure,imshow(curv{scale}{orient},[]);
%       n_lines=size(curv{scale}{orient},1);
%		disp([ ' orient: ' int2str(orient) ' n_lines: ' int2str(n_lines)]);

		disp([ ' orient: ' int2str(orient) ' size: ' int2str(size(curv{scale}{orient}))]);

      
      disp(['   curv min,max:' num2str(min(min(curv{scale}{orient},[],1),[],2)) ',' num2str(max(max(curv{scale}{orient},[],1),[],2))]);
      
      
 
         % Processat per separat de valors positius i negatius

            % Sequencial
      index_negatius = find(curv{scale}{orient}<0);
      index_positius = find(curv{scale}{orient}>=0);
      positius = curv{scale}{orient};
      negatius = -curv{scale}{orient};
      positius(index_negatius)=0;
      negatius(index_positius)=0;
      [gx_final,gy_final] = Qmodelinduction_v3_5(positius,prec,niter,2,'mirror',de,di);
      kk=mean(gx_final(:,:,:,1:niter),4);
      curv_final{scale}{orient}(index_positius)=kk(index_positius);
      [gx_final,gy_final] = Qmodelinduction_v3_5(negatius,prec,niter,2,'mirror',de,di);
      kk=mean(gx_final(:,:,:,1:niter),4);
      curv_final{scale}{orient}(index_negatius)=-kk(index_negatius);
      



      
      
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

      
      
      disp(['   kk min,max:' num2str(min(min(curv_final{scale}{orient},[],1),[],2)) ',' num2str(max(max(curv_final{scale}{orient},[],1),[],2))]);


      
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
   
    
end




		


end