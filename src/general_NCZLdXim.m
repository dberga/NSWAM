function [img,img_out]=general_NCZLdXim(estimul, nomexperiment)

 

% new OP
%addpath(strcat(pwd,'/','stimuli'));


%--------------------------------------------------------------------
% build the structure
clear strct struct wave zli display_plot compute 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Default parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

strct=get_default_parameters_NCZLd();

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


[tmp mult_tmp mult_name] = general_NCZLd_setstimulus(tmp,strct.compute.dynamic,strct.image.single_or_multiple,strct.image.gamma,strct.image.srgb_flag); %set to opponents

[strct.image.name] = strct.image.single;
          




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   core of the proces:\Users\xcerda\Desktop\Neurodinamic\codi V1 20_12_2013\stimuli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[img, img_out] = general_NCZLd_dispatcher(strct, tmp, mult_tmp);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%  output (opponents) to color, also get name %%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[img_out mult_tmp mult_name] = general_NCZLd_setstimulus_back(img_out,strct.compute.dynamic,strct.image.single_or_multiple,strct.image.gamma,strct.image.srgb_flag); %set to rgb


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


function [newtmp mult_tmp mult_name] = general_NCZLd_setstimulus(tmp,stimulus_type,single_or_multiple,gamma,srgb_flag)

    % static case
    if stimulus_type==0 
        if single_or_multiple==1 % only one stimulus

            newtmp = get_the_cstimulus(tmp,gamma,srgb_flag);%! color  to opponent
            
            mult_tmp = 0;
            mult_name = 0;
            
        elseif single_or_multiple==2 % three stimuli
            [tmp1,name1,tmp2,name2,tmp3,name3]=get_the_stimuli(tmp,gamma,srgb_flag);
            mult_tmp = [tmp1 tmp2 tmp3];
            mult_name = [name1 name2 name3];
            devlog('Estimul multiple');
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

function [newtmp mult_tmp mult_name] = general_NCZLd_setstimulus_back(tmp,stimulus_type,single_or_multiple,gamma,srgb_flag)

    % static case
    if stimulus_type==0 
        if single_or_multiple==1 % only one stimulus

            newtmp = get_the_ostimulus(tmp,gamma,srgb_flag);%!opponent to color
            
            mult_tmp = 0;
            mult_name = 0;
            
        elseif single_or_multiple==2 % three stimuli
            [tmp1,name1,tmp2,name2,tmp3,name3]=get_the_ostimuli(tmp,gamma,srgb_flag);
            mult_tmp = [tmp1 tmp2 tmp3];
            mult_name = [name1 name2 name3];
            devlog('Estimul multiple');
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



function [img img_out] = general_NCZLd_dispatcher(strct, tmp, mult_tmp )
    
    if strct.compute.dynamic==0 % static
            if strct.image.single_or_multiple==1
                for n=1:strct.compute.Nparam;
                    [img,img_out] = general_NCZLd_execSINGLE(tmp, strct);
                    general_NCZLd_plotSINGLE(img, img_out, strct,n);
                    general_NCZLd_storeSINGLE(img, img_out, strct,n);    
                end
            elseif strct.image.single_or_multiple==2
                  [tmp1 tmp2 tmp3] = mult_tmp(1:3);
                for n=1:strct.compute.Nparam;
                        [img1 img_out1 img2 img_out2 img3 img_out3] = general_NCZLd_execMULTIPLE(tmp1,tmp2,tmp3, strct);
                        general_NCZLd_plotMULTIPLE(img1, img_out1, img2, img_out2, img3, img_out3, strct,n);
                        general_NCZLd_storeMULTIPLE(img1, img_out1, img2, img_out2, img3, img_out3, strct,n);
                        img = [img1  img2  img3 ];
                        img_out = [img_out1 img_out2 img_out3];
                end
            else
                devlog('Error: variable image.single_or_multiple out of range [1,2]',4);
            end
    elseif strct.compute.dynamic==1 % dynamic
        
        for n=1:strct.compute.Nparam;
            [img,img_out] = general_NCZLd_execSINGLE(tmp, strct);
            general_NCZLd_plotSINGLE_dyn(img, img_out, strct,n);
            general_NCZLd_storeSINGLE_dyn(img, img_out, strct,n);
    
        end
    else
        devlog('Error: variable compute.dynamic out of range [1,2]',4);
    end

end

 
function [img,img_out] = general_NCZLd_execSINGLE(tmp, strct)
    [img,img_out] = NCZLd(tmp,strct);

end


function [img1 img_out1 img2 img_out2 img3 img_out3] = general_NCZLd_execMULTIPLE(tmp1,tmp2,tmp3, strct)
    [img1 img_out1] = general_NCZLd_execSINGLE(tmp1,strct);
    [img2 img_out2] = general_NCZLd_execSINGLE(tmp2,strct);
    [img3 img_out3] = general_NCZLd_execSINGLE(tmp3,strct);
    
end

function [] = general_NCZLd_plotSINGLE(img, img_out, strct,n)
    % plot/no plot
    if strct.display_plot.plot_io==1

        % plot
        %figure('Name',imageoutname)
            subplot(3,1,1),imshow(uint8(img));h=title('Visual stimulus');set(h,'FontSize',16);
                     subplot(3,1,2),imshow(uint8(img_out));h=title('Predicted brightness');set(h,'FontSize',16);
            subplot(3,1,3),plot(img(round((size(img,2)/2)),:,1),'--b');hold on
            plot(img_out(round((size(img_out,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
                     hold off;

    end
end

                    
function [] = general_NCZLd_plotMULTIPLE(img1, img_out1, img2, img_out2, img3, img_out3, strct,n)
    % plot/no plot
    if strct.display_plot.plot_io==1

        % plot
            % all (9x9: plot the three images/induced images/brightness profiles)
            if strct.display_plot.reduce==0
                figure('Name',imageoutname)
                    subplot(3,3,1),imshow(uint8(img1));colormap('gray');
                    subplot(3,3,2),imshow(uint8(img_out1));colormap('gray');
                    subplot(3,3,3),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
                    plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
                    subplot(3,3,4),imshow(uint8(img2));colormap('gray');
                    subplot(3,3,5),imshow(uint8(img_out2));colormap('gray');
                    subplot(3,3,6),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
                    plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
                    subplot(3,3,7),imshow(uint8(img3));colormap('gray');
                    subplot(3,3,8),imshow(uint8(img_out3));colormap('gray');
                    subplot(3,3,9),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
                    plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
            % reduced (only brightness profiles)
            elseif strct.display_plot.reduce==1
                figure('Name',imageoutname)
                    subplot(3,1,1),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
                    plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
                    subplot(3,1,2),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
                    plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
                    subplot(3,1,3),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
                    plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
            end    
    end
end

                        
function [] = general_NCZLd_storeSINGLE(img, img_out, strct,n)
    % store/ don't store
    if strct.display_plot.store==1
        % get the name
        str_delta=num2str(strct.zli.Delta);
        str_n=num2str(n);
        str_de1=num2str(strct.zli.dedi(1,1,n)); % 1,1,n for excitation, scale 1, nth parameters in the list 
        str_di1=num2str(strct.zli.dedi(2,1,n)); 
        str_de2=num2str(strct.zli.dedi(1,2,n)); 
        str_di2=num2str(strct.zli.dedi(2,2,n)); 
        str_de3=num2str(strct.zli.dedi(1,3,n)); 
        str_di3=num2str(strct.zli.dedi(2,3,n)); 
        %imageoutname=strcat(strct.image.name,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
        %                        '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
        %save([strct.compute.outputstr '' imageoutname],'img_out');
    end
end

                    
function [] = general_NCZLd_storeMULTIPLE(img1, img_out1, img2, img_out2, img3, img_out3, strct,n)
    % store/ don't store
    if strct.display_plot.store==1
        % get the name
        str_delta=num2str(strct.zli.Delta);
        str_n=num2str(n);
        str_de1=num2str(strct.zli.dedi(1,1,n)); % 1,1,n for excitation, scale 1, nth parameters in the list 
        str_di1=num2str(strct.zli.dedi(2,1,n)); 
        str_de2=num2str(strct.zli.dedi(1,2,n)); 
        str_di2=num2str(strct.zli.dedi(2,2,n)); 
        str_de3=num2str(strct.zli.dedi(1,3,n)); 
        str_di3=num2str(strct.zli.dedi(2,3,n)); 
        imageoutname=strcat(name1,'_',name2,'_',name3,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
        imageoutname1=strcat(name1,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
        imageoutname2=strcat(name2,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
        imageoutname3=strcat(name3,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
        save([strct.compute.outputstr '' imageoutname1],'img_out1');
        save([strct.compute.outputstr '' imageoutname2],'img_out2');
        save([strct.compute.outputstr '' imageoutname3],'img_out3');
    end    
end

function [] = general_NCZLd_plotSINGLE_dyn(img, img_out, strct,n)
    % plot/no plot
    if(strct.display_plot.plot_io==1)
        % rough verification
        %                     for ff=1:zli.total_iter % input
        %                        % figure;imshow(uint8(img(:,:,:,ff)),[]);
        %                     end
        %                     for ff=1:zli.total_iter % output
        %                         figure;imshow(uint8(img_out(:,:,:,ff)),[]);
        %                     end
        cut=zeros(size(img,2),strct.zli.n_membr);
        cut_out=zeros(size(img,2),strct.zli.n_membr);
        for ff=1:strct.zli.n_membr
            cut(:,ff)=img(round((size(img,2)/2)),:,1,ff);
            cut_out(:,ff)=img_out(round((size(img,2)/2)),:,1,ff);
            %figure;plot(cut(:,ff),'--b');hold on
            %    plot(cut_out(:,ff),'r');
        end
        % stimulus oscillation/central cell response
        q=[cut(round((size(img,2)/4)),:);cut_out(round((size(img,2)/2)),:)];	% Surround luminosity
        %                     q=[cut(round((size(img,2)/2)),:);cut_out(round((size(img,2)/2)),:)]; % RF luminosity
        window_size=5;
        h=ones(1,window_size)/window_size;
        w=imfilter(q(2,:),h,'symmetric');
        figure;plot((1:size(q,2)),q(1,:),'b');hold on
        plot((1:size(q,2)),q(2,:),'r');hold on
        plot((1:size(q,2)),w,'g','LineWidth',3)
        grid on;grid minor
        z=1;
    end
end

function [] = general_NCZLd_storeSINGLE_dyn(img, img_out, strct,n)
            % store/ don't store
            %strct.display_plot.store=1;      % always store in the dynamical case
     		if display_plot.store==1
     			save([struct.compute.outputstr '' 'img'],'img')
     			save([struct.compute.outputstr '' 'img_out'],'img_out')
     		end
end




