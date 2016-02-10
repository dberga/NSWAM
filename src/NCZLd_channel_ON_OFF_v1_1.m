function [curv_final_out, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = NCZLd_channel_ON_OFF_v1_1(curv_in,struct,channel)

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
nu_0=struct.csfparams.nu_0;
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
            switch compute.output_from_model
                case 'M&w'
                    % Si l'output de Z.Li es la senyal processada
                    curv_ON_final{t_membr}=curv_ON{t_membr}.*iFactor_ON{t_membr}*zli.normal_output; %M+.*w+
                    curv_OFF_final{t_membr}=-curv_OFF{t_membr}.*iFactor_OFF{t_membr}*zli.normal_output; %-(M-.*w-)
                case 'M'
                    % Si l'output de Z.Li es un factor
                     curv_ON_final{t_membr}=iFactor_ON{t_membr}.*(curv_ON{t_membr}~=0); %M+
                     curv_OFF_final{t_membr}=iFactor_OFF{t_membr}.*(curv_OFF{t_membr}~=0); %M-
                        %curv_ON_final{t_membr}=iFactor_ON{t_membr}*zli.normal_output;
                        %curv_OFF_final{t_membr}=iFactor_OFF{t_membr}*zli.normal_output;
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

%curv = {t}(fil,col,s,o)
%curv_final = {t}(fil,col,s,o)
%curv_final_out = {t}{s}{o}(fil,col)
%curv_ON = {t}(fil,col,s,o)
%curv_OFF = {t}(fil,col,s,o)
%curv_ON_final = {t}(fil,col,s,o)
%curv_OFF_final = {t}(fil,col,s,o)
%iFactor_ON = {t}(fil,col,s,o)
%iFactor_OFF = {t}(fil,col,s,o)
%iFactor =  {t}(fil,col,s,o)
%gy_final_ON =  {t}(fil,col,s,o)
%gy_final_OFF =  {t}(fil,col,s,o)
%gy_final_ALL =  {t traspuesto - se accede igual}(fil,col,s,o)

if struct.display_plot.store_irrelevant==1
store_matrix_givenparams_channel(gy_final_ON,'gy_final_ON',channel,struct);
store_matrix_givenparams_channel(gy_final_OFF,'gy_final_OFF',channel,struct);
store_matrix_givenparams_channel(gy_final_ALL,'gy_final_ALL',channel,struct);
end

r_gy_final_ON = redim_t_s_o(gy_final_ON);
r_gy_final_ON_meanized = tmatrix_to_matrix(r_gy_final_ON,struct,1);
r_gy_final_OFF = redim_t_s_o(gy_final_OFF);
r_gy_final_OFF_meanized = tmatrix_to_matrix(r_gy_final_OFF,struct,1);
%r_gy_final_ALL = redim_t_s_o(gy_final_ALL);
%r_gy_final_ALL_meanized = tmatrix_to_matrix(r_gy_final_ALL,struct,1);

display_tmatrix_channel(r_gy_final_ON,'gy_final_ON',channel,struct);
display_tmatrix_channel(r_gy_final_OFF,'gy_final_OFF',channel,struct);
%display_tmatrix_channel(gy_final_ALL,'gy_final_ALL',channel,struct);
display_matrix_channel(r_gy_final_ON_meanized,'gy_final_ON_meanized',channel,struct);
display_matrix_channel(r_gy_final_OFF_meanized,'gy_final_OFF_meanized',channel,struct);
%display_matrix_channel(r_gy_final_ALL_meanized,'gy_final_ALL_meanized',channel,struct);




end