function []=general_NCZLdXim(estimul, nomexperiment, strct_path)
 

% new OP
%addpath(strcat(pwd,'/','stimuli'));


%--------------------------------------------------------------------
% build the structure
clear strct struct wave zli display_plot compute 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Default parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%strct=get_default_parameters_NCZLd();
strct=load_default_parameters_NCZLd(strct_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Review nargin%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[tmp, strct.image.single] =  general_NCZLdXim_args(nargin, estimul, nomexperiment);

devlog(strcat('Nstripes in Model Neurodynamic: ',num2str(strct.image.nstripes))); 

														  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% computational setting %%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[strct.compute.dynamic , strct.zli.n_membr] = general_NCZLd_compsetting(tmp, strct.zli.n_membr);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%  stimulus (image) to opponent, also get name %%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[tmp] = general_NCZLd_setstimulus(tmp,strct.compute.dynamic,strct.image.single_or_multiple,strct.image.gamma,strct.image.srgb_flag); %set to opponents

[strct.image.name] = strct.image.single;
          




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   core of the proces:\Users\xcerda\Desktop\Neurodinamic\codi V1 20_12_2013\stimuli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


general_NCZLd_dispatcher(strct, tmp);



end


function [stimulus image_name] =  general_NCZLdXim_args(nargs, stimulus, im_name)
    
    switch nargs
        case 0
            image_name='Contrast_Yellow_Green_256';
        case 1
            image_name = 'ImatgePerParametre';
        otherwise
            image_name =  im_name;
    end
    
end

function [stimulus_type n_membr] = general_NCZLd_compsetting(tmp, n_membr)

    if (size(tmp, 4)>1)
        stimulus_type=1; % 0 stable/1 dynamic stimulus (default 0)
        n_membr=size(tmp,4);  % number of membrane time constant. One membrane time per frame of video;
    else
        stimulus_type=0;
    end

end


function [newtmp ] = general_NCZLd_setstimulus(tmp,stimulus_type,single_or_multiple,gamma,srgb_flag)

    % static case
    if stimulus_type==0 
        if single_or_multiple==1 % only one stimulus

            newtmp = get_the_cstimulus(tmp,gamma,srgb_flag);%! color  to opponent

        
        else
            devlog('Error: variable image.single_or_multiple out of range [1,2]',4);
        end
    %dynamic case
    else 
        ttmp = tmp;
        newtmp = zeros(size(ttmp,4));
        for t=1:size(ttmp,4)
            newtmp(:,:,:,t) = general_NCZLd_setstimulus(ttmp(:,:,:,t),0,single_or_multiple,gamma,srgb_flag); %x,y,channel,time
        end
    end

end

function [newtmp] = general_NCZLd_setstimulus_back(tmp,stimulus_type,single_or_multiple,gamma,srgb_flag)

    % static case
    if stimulus_type==0 
        if single_or_multiple==1 % only one stimulus

            newtmp = get_the_ostimulus(tmp,gamma,srgb_flag);%!opponent to color

        else
            devlog('Error: variable image.single_or_multiple out of range [1,2]',4);
        end
    %dynamic case
    else 
        ttmp = tmp;
        newtmp = zeros(size(ttmp,4));
        for t=1:size(ttmp,4)
            newtmp(:,:,:,t) = general_NCZLd_setstimulus_back(ttmp(:,:,:,t),0,single_or_multiple,gamma,srgb_flag); %x,y,channel,time
        end
    end

end



function [] = general_NCZLd_dispatcher(strct, tmp )
    
    if strct.compute.dynamic==0 % static
            if strct.image.single_or_multiple==1
                for n=1:strct.compute.Nparam;
                    general_NCZLd_execSINGLE(tmp, strct); 
                end
            else
                devlog('Error: variable image.single_or_multiple out of range [1,2]',4);
            end
    elseif strct.compute.dynamic==1 % dynamic
        
        for n=1:strct.compute.Nparam;
            general_NCZLd_execSINGLE(tmp, strct);
            
    
        end
    else
        devlog('Error: variable compute.dynamic out of range [1,2]',4);
    end

end

 
function [] = general_NCZLd_execSINGLE(tmp, strct)
    NCZLd(tmp,strct);

end



