function [curv_final_out, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = NCZLd_channel_ON_OFF_v1_1(curv_in,struct,channel, nstripes)

% from NCZLd_channel_ON_OFF_v1_1.m to Rmodelinductiond_v0_3_2.m

% separate ON and OFF channels
% start the recovering at the level of the wavelet/Gabor responses

% preallocate
curv_final_out=curv_in;

%-------------------------------------------------------
% make the structure explicit/get the parameters
zli=struct.zli;
display_plot=struct.display_plot;
compute=struct.compute;
image=struct.image;
% struct.zli  
% normalization
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
% initialize
for ff=1:n_membr
	n_orient=size(curv_in{ff}{1},2);
	curv{ff}=zeros([size(curv_in{ff}{1}{1}) fin_scale n_orient]);
	for s=1:fin_scale
		for o=1:n_orient
			curv{ff}(:,:,s,o)=curv_in{ff}{s}{o};
		end
	end
end

% number of scales
struct.wave.n_scales=fin_scale;

% forced activation of a given neuron population
if compute.XOP_activacio_neurona==1
    for ff=1:n_membr
        curv{ff}(64:66,64:66,1,1)=0.1;
    end
end

% initialize
curv_final=curv;
	 
index_ON=cell(n_membr,1);
index_OFF=cell(n_membr,1);

curv_ON=curv;
curv_OFF=curv;
curv_ON_final=curv;
curv_OFF_final=curv;
	 
% handle ON and OFF separately/together
for t_membr=1:n_membr
    index_OFF{t_membr} = find(curv{t_membr}<=0);  % was curv{orient}
    index_ON{t_membr} = find(curv{t_membr}>=0);
end

% choose the algorithm (separated, abs, quadratic) 
switch(ON_OFF)
    case 0 % separated
        for t_membr=1:n_membr
            curv_ON{t_membr} = curv{t_membr};
            curv_OFF{t_membr} = -curv{t_membr};
            curv_OFF{t_membr}(index_ON{t_membr})=0;
            curv_ON{t_membr}(index_OFF{t_membr})=0;
        end
        
        if(compute.parallel_ON_OFF==1)
            iFactor_ON_OFF=cell(2,1);
            curv_ON_OFF=cell(2,1);
            curv_ON_OFF{1}=curv_ON;
            curv_ON_OFF{2}=curv_OFF;
            p=compute.dir;
            jm=findResource('scheduler','type','jobmanager','Name',compute.jobmanager,'LookupURL','localhost')
            get(jm)
            job = createJob(jm);
            set(job,'FileDependencies',p)
            set(job,'PathDependencies',p)
            get(job)
            for i=1:2
                if i==1
                    type='ON';
                else
                    type='OFF';
                end
                t=createTask(job, @Rmodelinductiond_v0_3_2, 1, {curv_ON_OFF{i}, struct, type, channel});
            end
            submit(job)
            get(job,'Tasks')
            waitForState(job, 'finished');
            out = getAllOutputArguments(job);
            iFactor_ON=out{1};
            iFactor_OFF=out{2};
            destroy(job)
        else
            % positius +++++++++++++++++++++++++++++++++++++++++++++++++++
            %%% MAIN PROCESS %%%
            [iFactor_ON,gy_final_ON]=Rmodelinductiond_v0_3_2(curv_ON, struct, 'ON', channel); % note: iFactor is called "gx_final" at the core of the process
            %%% END MAIN PROCESS %%%
            
            % negatius ----------------------------------------------------
            %%% MAIN PROCESS %%%
            [iFactor_OFF,gy_final_OFF]=Rmodelinductiond_v0_3_2(curv_OFF, struct, 'OFF', channel); % note: iFactor is called "gx_final" at the core of the process
            %%% END MAIN PROCESS %%%
            iFactor=iFactor_ON;
        end
        
        for t_membr=1:n_membr
            switch compute.output_type
                case 'image'
                    % Si l'output de Z.Li es la senyal processada
                    curv_ON_final{t_membr}=curv_ON{t_membr}.*iFactor_ON{t_membr}*zli.normal_output;
                    curv_OFF_final{t_membr}=-curv_OFF{t_membr}.*iFactor_OFF{t_membr}*zli.normal_output;
                case 'saliency'
                    % Si l'output de Z.Li es un factor
                    curv_ON_final{t_membr}=iFactor_ON{t_membr}.*(curv_ON{t_membr}~=0);
                    curv_OFF_final{t_membr}=iFactor_OFF{t_membr}.*(curv_OFF{t_membr}~=0);
            end
            iFactor{t_membr}=iFactor_ON{t_membr}+iFactor_OFF{t_membr};
            gy_final_ALL{t_membr}=gy_final_ON{t_membr}+gy_final_OFF{t_membr};
            curv_final{t_membr}=curv_ON_final{t_membr}+curv_OFF_final{t_membr};
        end
        
        
    case 1 % abs
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=abs(curv{t_membr});
        end
        
        iFactor=Rmodelinductiond_v0_3_2(dades, struct);
        
        for t_membr=1:n_membr
            curv_final{t_membr}=curv{t_membr}.*iFactor{t_membr}*zli.normal_output;
            % 					 curv_final{t_membr}=iFactor{t_membr}*zli.normal_output;
        end
        
    case 2 % square (quadratic)
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=curv{t_membr}.*curv{t_membr};
        end
        
        iFactor=Rmodelinductiond_v0_3_2(dades, struct);
        
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

% save raw values for all
if struct.display_plot.store==1
   % save([image.name '_curv' channel '.mat'],'curv');
   % save([image.name '_curv_final' channel '.mat'],'curv_final');
   save([image.name '_curv_final_out' channel 'nstripes' num2str(nstripes) '.mat'],'curv_final_out');
    switch(ON_OFF)
        case 0
          %  save([image.name '_curv_ON' channel '.mat'],'curv_ON');
          %  save([image.name '_curv_OFF' channel '.mat'],'curv_OFF');
          %  save([image.name '_curv_ON_final' channel '.mat'],'curv_ON_final');
          %  save([image.name '_curv_OFF_final' channel '.mat'],'curv_OFF_final');
            save([image.name '_iFactor_ON' channel 'nstripes' num2str(nstripes) '.mat'],'iFactor_ON');
            save([image.name '_iFactor_OFF' channel 'nstripes' num2str(nstripes) '.mat'],'iFactor_OFF');
            save([image.name '_iFactor' channel 'nstripes' num2str(nstripes) '.mat'],'iFactor');
          %  save([image.name '_INH_ON' channel '.mat'],'gy_final_ON');
          %  save([image.name '_INH_OFF' channel '.mat'],'gy_final_OFF');
          %  save([image.name '_INH_ALL' channel '.mat'],'gy_final_ALL');
        case 1
          %  save([image.name '_iFactor' channel '.mat'],'iFactor');
        case 2
          %  save([image.name '_iFactor' channel '.mat'],'iFactor');
    end
end

% display for debuging
if plot_wavelet_planes==1
    figure;
    subplot(1,3,1),imagesc(curv{n_iter}{scale}{orient});colormap('gray');
    subplot(1,3,2),imagesc(iFactor(:,:,n_iter),[0 1]); colormap('gray');
    subplot(1,3,3),imagesc(curv_final{n_iter}{orient});colormap('gray');
    %      subplot(1,3,2),imagesc(generate_csf(curv_final{ff}{orient},scale,zli.nu_0,'intensity'));colormap('gray');
    %     subplot(1,3,3),imagesc(curv{n_iter}{scale}{orient}.*generate_csf(curv_final{ff}{orient},scale,zli.nu_0,'intensity'));colormap('gray')*0.5;
end


end
