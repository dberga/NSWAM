function [curv_final,iFactor] = NCZLd_channel_orient(curv,struct,scale)

%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
display_plot=struct.display_plot;
% compute=struct.compute;

% struct.zli
% normalization
%factor_normal=zli.normal_input;
normal_output=zli.normal_output;

n_iter=zli.niter;

ON_OFF=zli.ON_OFF;
nu_0=zli.nu_0;

% struct.
plot_wavelet_planes=display_plot.plot_wavelet_planes;

% struct.compute
% dynamic/constant
% dynamic=compute.dynamic;

n_orient=size(curv{1}{scale},2);




%-------------------------------------------------------
%factor_normal=param.normal_input;
% ON_OFF=param.ON_OFF;
% genpar=param.genpar;

% if dynamic==1
%     n_orient=size(curv,3);
% else    
%     n_orient=size(curv,2);
% end





disp([ ' n_orient: ' int2str(n_orient)])

curv_final=cell(size(curv,1),size(curv,3));
iFactor=curv_final;  % warning! iFactor is not a cell anymore!


for orient=1:n_orient
	wav.scale=scale;
	wav.orient=orient;
    
    curvs=zeros(size(curv{1}{scale}{orient},1),size(curv{1}{scale}{orient},2),n_iter);
    for ff=1:n_iter
        curvs(:,:,ff)=curv{ff}{scale}{orient};
    end
    
    
    % display orientations
    disp([ ' orient: ' int2str(orient) ' size: ' int2str(size(curv{1}{scale}{orient}))]);
    % comment OP since min(cell) gives 'error'
    %    disp(['   curv min,max:' num2str(min(min(curv{orient},[],1),[],2)) ','...
    %                num2str(max(max(curv{orient},[],1),[],2))]);
    
    % processa per separat els valors positius i negatius
    % sequencial
    index_negatius = find(curvs<0);  % was curv{orient}
    index_positius = find(curvs>0);
    
    switch(ON_OFF)
        case 0 % separat
            positius = curvs;
            negatius = -curvs;
            positius(index_negatius)=0;
            negatius(index_positius)=0;
            
            % positius +++++++++++++++++++++++++++++++++++++++++++++++++++
            
            temp_iFactor=Zaoping_Li(positius, struct,wav);
            
            a=zeros(size(temp_iFactor));
            a(index_positius)=temp_iFactor(index_positius);
            
            % negatius ----------------------------------------------------
            
            temp_iFactor=Zaoping_Li(negatius, struct,wav);
            
            a(index_negatius)=temp_iFactor(index_negatius);
            
            iFactor_tmp=a;
            
        case 1 % abs
            dades=curvs;
            dades(index_negatius)=-dades(index_negatius);
            iFactor_tmp=Zaoping_Li(dades, struct,wav);
            
        case 2 % square
            dades=curvs.*curvs;
            iFactor_tmp=Zaoping_Li(dades, struct,wav);
    end
    
    if(iFactor_tmp(:)>1)
        disp('ERROR: iFactor >1 !!!')
    end
    
    iFactor_tmp=normal_output*iFactor_tmp;

    for ff=1:n_iter
        curv_final{ff}{orient}=curv{ff}{scale}{orient}.*iFactor_tmp(:,:,ff);
        % 		  curv_final{ff}{orient}=iFactor(:,:,ff);
        iFactor{ff}{orient}=iFactor_tmp(:,:,ff);
    end
    
    if plot_wavelet_planes==1
        figure;
        subplot(1,3,1),imagesc(curv{n_iter}{scale}{orient});colormap('gray');
        subplot(1,3,2),imagesc(iFactor(:,:,n_iter),[0 1]); colormap('gray');
        subplot(1,3,3),imagesc(curv_final{n_iter}{orient});colormap('gray');
        %      subplot(1,3,2),imagesc(generate_csf(curv_final{ff}{orient},scale,zli.nu_0,'intensity'));colormap('gray');
        %     subplot(1,3,3),imagesc(curv{n_iter}{scale}{orient}.*generate_csf(curv_final{ff}{orient},scale,zli.nu_0,'intensity'));colormap('gray')*0.5;
    end
    
    
    % disp(['   kk min,max:' num2str(min(min(curv_final{orient},[],1),[],2)) ',' num2str(max(max(curv_final{orient},[],1),[],2))]);
end



end