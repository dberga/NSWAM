
% mirror of find_parameters_general_NCZLd.m

% read the output of find_parameters_general_NCZLd.m
% uses the same description of parameters
% recontruct the names and get the images

% toward a good set of parameters (created 14/9/12)
% based on [img,img_out]=general_NCZLd(image_name,mida_min,epsilon,kappay,normal_output) 

% 1. images we want to analyze
% names={'che_128','whi_128'};  % debug only
names={'mach_256','che_256','whi_256','SBC1_256','grating_256'};

        % 1'. choose and image
            only_one=1;
            which_one=4;

% 2. values for mida_min
mida_min=[32,16];

% 3. values for epsilon
epsilon=(0.7:0.15:1.3);

% 4. values for kappay
kappay=(1:0.25:1.75);

% 5. values for normal_output
normal_output=(1.25:0.25:1.75);

% loop over the parameters
%for i2=1:size(mida_min,2)
%    for i3=1:size(epsilon,2)
i2=1; 
i3=3;
for i4=1:size(kappay,2)
    for i5=1:size(normal_output,2)
        if only_one==1
            % prepare the name
                nmida_min=num2str(mida_min(i2));
                nepsilon=num2str(epsilon(i3));
                nkappay=num2str(kappay(i4));
                nnormal_output=num2str(normal_output(i5));
                image_name=names{which_one};
                % get the name
                image.name=strcat(image_name,'_min_freq_',nmida_min,'_epsilon_',nepsilon,...
                    '_kappay_',nkappay,'_normal_output_',nnormal_output);
                name_in=strcat(image.name, '_img.mat');
                name_out=strcat(image.name, '_img_out.mat');
                load(name_in)
                load(name_out)
                img_out_mean=mean(img_out(:,:,:,4:end),4);
                % plot the result
                figure('Name',name_out)
                plot(img(round((size(img,2)/2)),:,1),'--b');hold on
                plot(img_out_mean(round((size(img_out_mean,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
                hold off;
                [x,y] = ginput(1)
        else
            for i1=1:size(names,2)
                % prepare the name
                nmida_min=num2str(mida_min(i2));
                nepsilon=num2str(epsilon(i3));
                nkappay=num2str(kappay(i4));
                nnormal_output=num2str(normal_output(i5));
                image_name=names{i1};
                % get the name
                image.name=strcat(image_name,'_min_freq_',nmida_min,'_epsilon_',nepsilon,...
                    '_kappay_',nkappay,'_normal_output_',nnormal_output);
                name_in=strcat(image.name, '_img.mat');
                name_out=strcat(image.name, '_img_out.mat');
                load(name_in)
                load(name_out)
                img_out_mean=mean(img_out(:,:,:,4:end),4);
                % plot the result
                figure('Name',name_out)
                plot(img(round((size(img,2)/2)),:,1),'--b');hold on
                plot(img_out_mean(round((size(img_out_mean,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
                hold off;
                [x,y] = ginput(1)
            end
        end
    end
end

