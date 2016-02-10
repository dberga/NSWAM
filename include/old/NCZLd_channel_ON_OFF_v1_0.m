function [curv_final_out, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = NCZLd_channel_ON_OFF_v1_0(curv_in,struct)


curv_final_out=curv_in;

%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
display_plot=struct.display_plot;
compute=struct.compute;

% struct.zli
% normalization
%factor_normal=zli.normal_input;
normal_output=zli.normal_output;

% n_iter=zli.niter;

n_membr=zli.n_membr;

ON_OFF=zli.ON_OFF;
nu_0=zli.nu_0;

% struct.
plot_wavelet_planes=display_plot.plot_wavelet_planes;

% struct.compute
% dynamic/constant
% dynamic=compute.dynamic;

% n_orient=size(curv{1}{scale},2);

n_scales=struct.wave.n_scales;
fin_scale=struct.wave.fin_scale;


%-------------------------------------------------------

curv=cell(n_membr,1);
for ff=1:n_membr
	n_orient=size(curv_in{ff}{1},2);
	curv{ff}=zeros([size(curv_in{ff}{1}{1}) fin_scale n_orient]);
	for s=1:fin_scale
		for o=1:n_orient
			curv{ff}(:,:,s,o)=curv_in{ff}{s}{o};
		end
	end
end


struct.wave.n_scales=fin_scale;

%factor_normal=param.normal_input;
% ON_OFF=param.ON_OFF;
% genpar=param.genpar;

% if dynamic==1
%     n_orient=size(curv,3);
% else    
%     n_orient=size(curv,2);
% end





% disp([ ' n_orient: ' int2str(n_orient)])

% curv_final=cell(size(curv,1),size(curv,3));
% iFactor=curv_final;  % warning! iFactor is not a cell anymore!


% for orient=1:n_orient
% 	wav.scale=scale;
% 	wav.orient=orient;
%     
%     curvs=zeros(size(curv{1}{scale}{orient},1),size(curv{1}{scale}{orient},2),n_iter);
%     for ff=1:n_iter
%         curvs(:,:,ff)=curv{ff}{scale}{orient};
%     end
    
    
    % display orientations
%     disp([ ' orient: ' int2str(orient) ' size: ' int2str(size(curv{1}{scale}{orient}))]);
    % comment OP since min(cell) gives 'error'
    %    disp(['   curv min,max:' num2str(min(min(curv{orient},[],1),[],2)) ','...
    %                num2str(max(max(curv{orient},[],1),[],2))]);
    
    % processa per separat els valors positius i negatius
    % sequencial

	 
	 if compute.XOP_activacio_neurona==1
		 for ff=1:n_membr
			 curv{ff}(64:66,64:66,1,1)=0.1;
		 end
	 end
	 
	 curv_final=curv;
	 
	 index_ON=cell(n_membr,1);
	 index_OFF=cell(n_membr,1);

	 curv_ON=curv;
	 curv_OFF=curv;
	 curv_ON_final=curv;
	 curv_OFF_final=curv;
	 
	 
% 	 curv_ON{t_membr}=zeros(size(curv{t_membr}));
% 	 curv_OFF{t_membr}=zeros(size(curv{t_membr}));
% 	 
	 
	 
	 for t_membr=1:n_membr
		 index_OFF{t_membr} = find(curv{t_membr}<=0);  % was curv{orient}
		 index_ON{t_membr} = find(curv{t_membr}>=0);
	 end

	 
		 switch(ON_OFF)
			 case 0 % separat
				 for t_membr=1:n_membr
                     curv_ON{t_membr} = curv{t_membr};
                     curv_OFF{t_membr} = -curv{t_membr};
                     curv_OFF{t_membr}(index_ON{t_membr})=0;
                     curv_ON{t_membr}(index_OFF{t_membr})=0;
				 end
				 

				 if(compute.parallel_ON_OFF==1)
					 p=compute.dir;
					 jm=findResource('scheduler','type','jobmanager','Name',compute.jobmanager,'LookupURL','localhost')
					 % 	jm=findResource('scheduler','configuration',defaultParallelConfig);
					 get(jm)
					 % 	matlabpool(jm)
					 job = createJob(jm);
					 set(job,'FileDependencies',p)
					 set(job,'PathDependencies',p)
					 get(job)
					 
					 
					 iFactor_ON_OFF=cell(2,1);
					 curv_ON_OFF=cell(2,1);
					 curv_ON_OFF{1}=curv_ON;
					 curv_ON_OFF{2}=curv_OFF;
					 
					 parfor i=1:2
						 t=createTask(job, @Rmodelinductiond_v0_1, 1, {curv_ON_OFF{i}, struct});
% 							 iFactor_ON_OFF{i}=Rmodelinductiond_v0_1(curv_ON_OFF{i}, struct);
					 end
					 submit(job)
					 get(job,'Tasks')
					 
					 
					 waitForState(job, 'finished');
					 
					 for i=ini_scale:n_scales
						 job.Tasks(scale-ini_scale+1).ErrorMessage
					 end
					 
					 out = getAllOutputArguments(job);
					 
					 
					 iFactor_ON=out{1};
					 iFactor_OFF=out{2};
					 
					 destroy(job)
					 
				 else
					 
					 
					 
					 
					 % positius +++++++++++++++++++++++++++++++++++++++++++++++++++
					 
					 
					 iFactor_ON=Rmodelinductiond_v0_2(curv_ON, struct);
					 
% 					 for t_membr=1:n_membr
% 						 curv_final{t_membr}(index_ON{t_membr})=tmp_ON{t_membr}(index_ON{t_membr});
% 					 end
					 
					 % negatius ----------------------------------------------------
					 
					 
					 iFactor_OFF=Rmodelinductiond_v0_2(curv_OFF, struct);
					 
					 iFactor=iFactor_ON;
% 					 for t_membr=1:n_membr
% 						 curv_final{t_membr}(index_OFF{t_membr})=tmp_OFF{t_membr}(index_OFF{t_membr});
% 					 end
% 					 
% 					 m_iFactor=cell(n_membr,1);
% 					 for t=1:n_membr
% 						 m_iFactor=mean(mean(iFactor_ON{t},1),2);
% 						 std_iFactor=mean(mean(iFactor_ON{t},1),2);
% 						 iFactor_ON{t}=iFactor_ON{t}
% 					 end
				 end

				for t_membr=1:n_membr
					% Si l'output de Z.Li es un factor
					curv_ON_final{t_membr}=curv_ON{t_membr}.*iFactor_ON{t_membr}*zli.normal_output;
					curv_OFF_final{t_membr}=-curv_OFF{t_membr}.*iFactor_OFF{t_membr}*zli.normal_output;
					% Si l'output de Z.Li es la senyal processada
% 					curv_ON_final{t_membr}=iFactor_ON{t_membr};
% 					curv_OFF_final{t_membr}=-iFactor_OFF{t_membr};
					iFactor{t_membr}=iFactor_ON{t_membr}+iFactor_OFF{t_membr};
					curv_final{t_membr}=curv_ON_final{t_membr}+curv_OFF_final{t_membr};
				end


			 case 1 % abs
				 dades=curv;
				 for t_membr=1:n_membr
					dades{t_membr}=abs(curv{t_membr});
				 end
				 
				 iFactor=Rmodelinductiond_v0_2(dades, struct);
				 
				 for t_membr=1:n_membr
					 curv_final{t_membr}=curv{t_membr}.*iFactor{t_membr}*zli.normal_output;
% 					 curv_final{t_membr}=iFactor{t_membr}*zli.normal_output;
				 end
				 
			 case 2 % square
				 dades=curv;
				 for t_membr=1:n_membr
					dades{t_membr}=curv{t_membr}.*curv{t_membr};
				 end
				 
				 iFactor=Rmodelinductiond_v0_2(dades, struct);
				 
				 for t_membr=1:n_membr
					 curv_final{t_membr}=curv{t_membr}.*iFactor{t_membr}*zli.normal_output;
				 end
		 end

		 
		for ff=1:n_membr
			for s=1:fin_scale
				for o=1:n_orient
					curv_final_out{ff}{s}{o}=curv_final{ff}(:,:,s,o);
% 					iFactor{ff}{s}{o}=iFactortmp{ff}(:,:,s,o);
				end
			end
		end
		 
		if struct.display_plot.store==1
			save('curv','curv');
			save('curv_final','curv_final');
			switch(ON_OFF)
				case 0
					save('curv_ON','curv_ON');
					save('curv_OFF','curv_OFF');
					save('curv_ON_final','curv_ON_final');
					save('curv_OFF_final','curv_OFF_final');
					save('iFactor_ON','iFactor_ON');
					save('iFactor_OFF','iFactor_OFF');
					save('iFactor','iFactor');
				case 1
					save('iFactor','iFactor');
				case 2
					save('iFactor','iFactor');
			end
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
% end

% 		for ff=1:n_membr
% 			for s=1:fin_scale
% 				for o=1:n_orient
% 					curv_final_out{ff}{s}{o}=curv_final{ff}(:,:,s,o);
% % 					iFactor{ff}{s}{o}=iFactortmp{ff}(:,:,s,o);
% 				end
% 			end
% 		end


end