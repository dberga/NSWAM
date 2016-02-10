function [curv_final,iFactor] = NCZL_channel_orient(curv,struct,n,scale)


%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
display_plot=struct.display;

% struct.zli
% normalization
factor_normal=zli.normal_input;

n_iter=zli.niter;

ON_OFF=zli.ON_OFF;
nu_0=zli.nu_0;

% struct.
plot_wavelet_planes=display_plot.plot_wavelet_planes;

%-------------------------------------------------------
%factor_normal=param.normal_input;
% ON_OFF=param.ON_OFF;
% genpar=param.genpar;


n_orient=size(curv,2);
disp([ ' n_orient: ' int2str(n_orient)])

curv_final=curv;
iFactor=curv_final;
  

for orient=1:n_orient
    % display orientations
    disp([ ' orient: ' int2str(orient) ' size: ' int2str(size(curv{orient}))]);
    disp(['   curv min,max:' num2str(min(min(curv{orient},[],1),[],2)) ','...
                num2str(max(max(curv{orient},[],1),[],2))]);
      
    % processa per separat els valors positius i negatius
    % sequencial
	index_negatius = find(curv{orient}<0);
    index_positius = find(curv{orient}>0);

	switch(ON_OFF)
                case 0 % separat
                    positius = curv{orient};
                    negatius = -curv{orient};
                    positius(index_negatius)=0;
                    negatius(index_positius)=0;

                    % positius +++++++++++
                    % kk=Zaoping_Li(positius, factor_normal, prec,niter,de,di,genpar,scale);
                    % iFactor{orient}(index_positius)=kk(index_positius);
                    
                    % new version (shunt Zaoping_Li)
                    % normalitzacio
                    shift=1;
                    normal=max(max(abs(positius)));
                    if normal~=0
                        positius=positius/normal*(factor_normal-shift)+shift;
                    end
                    % dynamical system
                    [gx_final,gy_final] = Qmodelinduction_v4_0(positius,struct,n,scale);
                    % was   dades,prec,niter,2,'mirror',de,di,genpar,scale);
                    % mean over the membrane time constants
                    temp_iFactor=mean(gx_final(:,:,:,1:n_iter),4);
                    % get iFactor
                    iFactor{orient}(index_positius)=temp_iFactor(index_positius);

                    % negatius ------------
                    %kk=Zaoping_Li(negatius, factor_normal, prec,niter,de,di,genpar,scale);
                    %iFactor{orient}(index_negatius)=kk(index_negatius);
                    
                    % normalitzacio
                    shift=1;
                    normal=max(max(abs(negatius)));
                    if normal~=0
                        negatius=negatius/normal*(factor_normal-shift)+shift;
                    end
                    % dynamical system
                    [gx_final,gy_final] = Qmodelinduction_v4_0(negatius,struct,n,scale);
                    % was   dades,prec,niter,2,'mirror',de,di,genpar,scale);
                    % mean over the membrane time constants
                    temp_iFactor=mean(gx_final(:,:,:,1:n_iter),4);
                    % get iFactor
                    iFactor{orient}(index_negatius)=temp_iFactor(index_negatius);

                case 1 % abs
                    dades=curv{orient};
                    dades(index_negatius)=-dades(index_negatius);				
                    iFactor{orient}=Zaoping_Li(dades, factor_normal, prec,n_iter,de,di,genpar,scale);

                case 2 % square
                    dades=curv{orient}.*curv{orient};				
                    iFactor{orient}=Zaoping_Li(dades, factor_normal, prec,n_iter,de,di,genpar,scale);
	end
	
		iFactor{orient}=iFactor{orient}.*iFactor{orient};
		curv_final{orient}=curv{orient}.*iFactor{orient};
		

if plot_wavelet_planes==1 
    figure;
    subplot(1,3,1),imagesc(curv{orient});colormap('gray');
    subplot(1,3,2),imagesc(iFactor{orient},[0 1]); colormap('gray');
    subplot(1,3,3),imagesc(curv_final{orient});colormap('gray');
end    

      
disp(['   kk min,max:' num2str(min(min(curv_final{orient},[],1),[],2)) ',' num2str(max(max(curv_final{orient},[],1),[],2))]);
end



end