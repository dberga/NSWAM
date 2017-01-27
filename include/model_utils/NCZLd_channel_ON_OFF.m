function [iFactor_single,iFactor_out, x_ON,x_OFF, y_ON, y_OFF] = NCZLd_channel_ON_OFF(w,struct, x_on, x_off, y_on, y_off)



[curv] = multires_decomp2curv(w,[],struct.wave_params.n_scales,struct.wave_params.n_orient);
[curv_in] = dyncopy_curv(curv,struct.zli_params.n_membr,struct.wave_params.n_scales,struct.wave_params.n_orient);




% from NCZLd_channel_ON_OFF.m to Rmodelinductiond.m

% separate ON and OFF channels
% start the recovering at the level of the wavelet/Gabor responses



n_iter=struct.zli_params.n_iter;
n_membr=struct.zli_params.n_membr;

n_orient=size(struct.wave_params.n_orient);
n_scales=struct.wave_params.n_scales;
fin_scale=struct.wave_params.fin_scale;

iFactor = cell(n_membr,n_iter);
iFactor_ON = cell(n_membr,n_iter);
iFactor_OFF = cell(n_membr,n_iter);
jFactor = cell(n_membr,n_iter);
jFactor_ON = cell(n_membr,n_iter);
jFactor_OFF = cell(n_membr,n_iter);

%-------------------------------------------------------
% make the structure explicit/get the parameters







%-------------------------------------------------------
%prepare curv

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



if nargin < 4 || struct.gaze_params.conserve_dynamics == 0
   x_on = zeros(size(curv{1}));
   y_on = zeros(size(curv{1}));
   x_off = zeros(size(curv{1}));
   y_off = zeros(size(curv{1}));
end


% forced activation of a given neuron population
if struct.compute_params.XOP_activacio_neurona==1
    for ff=1:n_membr
        curv{ff}(64:66,64:66,1,1)=0.1;
    end
end

%-------------------------------------------------------
%prepare curv_ON, curv_OFF


% initialize input of ND
curv_ON=cell(n_membr,1);
curv_OFF=cell(n_membr,1);
	 
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

for t_membr=1:n_membr
            curv_ON{t_membr} = curv{t_membr};
            curv_OFF{t_membr} = -curv{t_membr};
            curv_OFF{t_membr}(index_ON{t_membr})=0;
            curv_ON{t_membr}(index_OFF{t_membr})=0;
end
        
%-------------------------------------------------------

%Rmodelinduction uses n_scales without the last one, which is from curv
aux_n_scales = struct.wave_params.n_scales;
struct.wave_params.n_scales = struct.wave_params.fin_scale;

% choose the algorithm (separated, abs, quadratic) 
switch(struct.zli_params.ON_OFF)
    case 0 % separated
        
            aux_ior_matrix = struct.gaze_params.ior_matrix;
            
            % positius +++++++++++++++++++++++++++++++++++++++++++++++++++
            %%% MAIN PROCESS %%%
            [xFactor_ON_t_fi,yFactor_ON_t_fi,xFactor_ON_t_i,yFactor_ON_t_i,x_ON, y_ON]=Rmodelinductiond(curv_ON, struct, 'ON',x_on,y_on); % note: iFactor is called "gx_final" at the core of the process
            %%% END MAIN PROCESS %%%
            
            struct.gaze_params.ior_matrix = aux_ior_matrix; %same for ON and OFF, the (OFF) will save the last ior_matrix
            
            % negatius ----------------------------------------------------
            %%% MAIN PROCESS %%%
            [xFactor_OFF_t_fi,yFactor_OFF_t_fi,xFactor_OFF_t_i,yFactor_OFF_t_i,x_OFF, y_OFF]=Rmodelinductiond(curv_OFF, struct,  'OFF', x_off, y_off); % note: iFactor is called "gx_final" at the core of the process

            for t_membr=1:n_membr
                for it=1:n_iter
                    
                    %this should be done after the whole routine
                    switch struct.fusion_params.output_from_model
                    case 'M&w'
                        % Si l'output de Z.Li es la senyal processada
                        iFactor_ON{t_membr}{it}=curv_ON{t_membr}.*xFactor_ON_t_i{t_membr}{it}*struct.zli_params.normal_output; %gx+.*w+
                        iFactor_OFF{t_membr}{it}=-curv_OFF{t_membr}.*xFactor_OFF_t_i{t_membr}{it}*struct.zli_params.normal_output; %-(gx-.*w-)
                        jFactor_ON{t_membr}{it}=-curv_ON{t_membr}.*yFactor_ON_t_i{t_membr}*struct.zli_params.normal_output; %-(gy-.*w-)
                        jFactor_OFF{t_membr}{it}=-curv_OFF{t_membr}.*yFactor_OFF_t_i{t_membr}*struct.zli_params.normal_output; %-(gy-.*w-)
                        
                        
                    case 'M'
                        % Si l'output de Z.Li es un factor
                         %iFactor_ON{t_membr}{it}=xFactor_ON_t_i{t_membr}{it}.*(curv_ON{t_membr}~=0); %gx+
                         %iFactor_OFF{t_membr}{it}=xFactor_OFF_t_i{t_membr}{it}.*(curv_OFF{t_membr}~=0); %gx-
                            iFactor_ON{t_membr}{it}=xFactor_ON_t_i{t_membr}{it}*struct.zli_params.normal_output;
                            iFactor_OFF{t_membr}{it}=xFactor_OFF_t_i{t_membr}{it}*struct.zli_params.normal_output;
                         %jFactor_ON{t_membr}{it}=yFactor_ON_t_i{t_membr}{it}.*(curv_ON{t_membr}~=0); %gy+
                         %jFactor_OFF{t_membr}{it}=yFactor_OFF_t_i{t_membr}{it}.*(curv_OFF{t_membr}~=0); %gy-
                            jFactor_ON{t_membr}{it}=yFactor_ON_t_i{t_membr}{it}*struct.zli_params.normal_output;
                            jFactor_OFF{t_membr}{it}=yFactor_OFF_t_i{t_membr}{it}*struct.zli_params.normal_output;
                    end
                    iFactor{t_membr}{it}=iFactor_ON{t_membr}{it}+iFactor_OFF{t_membr}{it};
                    jFactor{t_membr}{it}=jFactor_ON{t_membr}{it}+jFactor_OFF{t_membr}{it};
                    
                    x_out = x_ON + x_OFF;
                    y_out = y_ON + y_OFF;
                end
            end
        
    case 1 % abs
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=abs(curv{t_membr});
        end
        
        [xFactor_t_fi,yFactor_t_fi,xFactor_t_i,yFactor_t_i,struct]=Rmodelinductiond(dades, struct,'','',x_on,y_on);
        
        for t_membr=1:n_membr
            for it=1:n_iter
                iFactor{t_membr}{it}=curv{t_membr}.*xFactor_t_i{t_membr}{it}*struct.zli_params.normal_output;
            end
        end
        
    case 2 % square (quadratic)
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=curv{t_membr}.*curv{t_membr};
        end
        
        [xFactor_t_fi,yFactor_t_fi,xFactor_t_i,yFactor_t_i,struct]=Rmodelinductiond(dades, struct,'','',x_on,y_on);
        
        for t_membr=1:n_membr
            for it=1:n_iter
                iFactor{t_membr}{it}=curv{t_membr}.*xFactor_t_fi{t_membr}{it}*struct.zli_params.normal_output;
            end
        end
end


for ff=1:n_membr
    for it=1:n_iter
        for s=1:fin_scale
            for o=1:n_orient
                iFactor_out{ff}{it}{s}(:,:,o)=iFactor{ff}{it}(:,:,s,o);
                iFactor_single{s}(:,:,o) = iFactor{ff}{it}(:,:,s,o);
            end
        end
        %last scale es la approximada
        %iFactor_out{ff}{it}{n_scales}= curv_in{ff}{n_scales};
    end
end

struct.wave_params.n_scales = aux_n_scales;


end
