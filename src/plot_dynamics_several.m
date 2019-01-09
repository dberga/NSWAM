
function [  ] = plot_dynamics_spec( model_name, images_list, mats_path, gaze, masks_path)

addpath(genpath('include'));
addpath(genpath('src'));

if nargin<1, model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault'; end

for analysis=1:9
%% evaluation params


    switch(analysis)
        case 1
            block=10;
            block_cond=1;
            channel=3;
            sfreq=3;
            orient=1:3;
            Title = 'Brigthness Contrast (T: Gray, B: Dark)';
            Legend={'\DeltaL = 0','\DeltaL = .08','\DeltaL = .17','\DeltaL = .25','\DeltaL = .33','\DeltaL = .41','\DeltaL = .5'};
            colors=flipud(repmat((0:(7-1))/(7),3,1)');
        case 2
            block=10;
            block_cond=2;
            channel=3;
            sfreq=3;
            orient=1:3;
            Title = 'Brigthness Contrast (T: Gray, B: White)';
            Legend={'\DeltaL = 0','\DeltaL = .08','\DeltaL = .17','\DeltaL = .25','\DeltaL = .33','\DeltaL = .41','\DeltaL = .5'};
            colors=repmat((0:(7-1))/(7),3,1)';

        case 3
            block=9;
            block_cond=1;
            channel=1;
            sfreq=3;
            orient=1:3;
            Title = 'Color Contrast (T: Red, B: Gray)';
            Legend={'\DeltaS = 0','\DeltaS = .12','\DeltaS = .25','\DeltaS = .37','\DeltaS = .53','\DeltaS = .73','\DeltaS = 1'};
            colors=0.5*ones(7,3);
            colors(:,1)=0.5:(1/12):1;

        case 4
            block=9;
            block_cond=2;
            channel=1;
            sfreq=3;
            orient=1:3;
            Title = 'Color Contrast (T: Red, B: Red)';
            Legend={'\DeltaS = 0','\DeltaS = .12','\DeltaS = .25','\DeltaS = .37','\DeltaS = .53','\DeltaS = .73','\DeltaS = 1'};
            colors=0.5*ones(7,3);
            colors(:,1)=0.5:(1/12):1;

        case 5
            block=9;
            block_cond=3;
            channel=2;
            sfreq=3;
            orient=1:3;
            Title = 'Color Contrast (T: Blue, B: Gray)';
            Legend={'\DeltaS = 0','\DeltaS = .12','\DeltaS = .25','\DeltaS = .37','\DeltaS = .53','\DeltaS = .73','\DeltaS = 1'};
            colors=0.5*ones(7,3);
            colors(:,3)=0.5:(1/12):1;

        case 6
            block=9;
            block_cond=4;
            channel=2;
            sfreq=3;
            orient=1:3;
            Title = 'Color Contrast (T: Blue, B: Red)';
            Legend={'\DeltaS = 0','\DeltaS = .12','\DeltaS = .25','\DeltaS = .37','\DeltaS = .53','\DeltaS = .73','\DeltaS = 1'};
            colors=0.5*ones(7,3);
            colors(:,3)=0.5:(1/12):1;

        case 7
            block=11;
            block_cond=1;
            channel=3;
            sfreq=3;
            orient=1:3;
            Title = 'Size Contrast';
            %Legend={'1.25 deg','1.67 deg','2.08 deg','2.5 deg','3.34 deg','4.17 deg','5 deg'};
            Legend={'.5','.67','.83','1','1.34','1.67','2'};
            colors=repmat((0:(7-1))/(7),3,1)';

        case 8
            block=12;
            block_cond=1;
            channel=3;
            sfreq=3;
            orient=1:3;
            Title = 'Angle Contrast';
            Legend={'\Delta\Theta = 0º','\Delta\Theta = 10º','\Delta\Theta = 20 º','\Delta\Theta = 30 º','\Delta\Theta = 42 º','\Delta\Theta = 56 º','\Delta\Theta = 90 º'};
            colors=[1 0 0; 1 0.5 0; 0 1 0; 0 1 0.5; 0 1 1; 0 0.5 1; 0 0 1];

        case 9
            block=13;
            block_cond=1;
            channel=3;
            sfreq=3;
            orient=1:3;
            Title = 'Angle Contrast';
            Legend={'\Delta\Theta = 0º','\Delta\Theta = 10º','\Delta\Theta = 20 º','\Delta\Theta = 30 º','\Delta\Theta = 42 º','\Delta\Theta = 56 º','\Delta\Theta = 90 º'};
            colors=[1 0 0; 1 0.5 0; 0 1 0; 0 1 0.5; 0 1 1; 0 0.5 1; 0 0 1];
    end

    if nargin < 2, 
        %images_list = {'input_sid4vam/d1Bvs4BrTGwBB1.png','input_sid4vam/d1Bvs4BrTGwBB0p83333.png','input_sid4vam/d1Bvs4BrTGwBB0p66667.png','input_sid4vam/d2Bvs4BrTGwBB0p5.png','input_sid4vam/d2Bvs4BrTGwBB0p33333.png','input_sid4vam/d2Bvs4BrTGwBB0p16667.png','input_sid4vam/d2Bvs4BrTGwBB0.png'};
        images_list=block2imageslist(block,block_cond);
    end
    if nargin < 3, mats_path=['mats_sid4vam/' model_name ]; end
    if nargin < 4, gaze = 1; end
    if nargin < 5, masks_path=['/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/mmaps']; end

    for i=1:length(images_list)
        [image_folder,image_name_noext,ext]=fileparts(images_list{i});
        masks_list{i}=[masks_path '/' image_name_noext ext];
    end

    channels={'chromatic','chromatic2','intensity'};



    for i=1:length(images_list)

        [filepath,name,ext] = fileparts(images_list{i});
        struct_path=[mats_path '/' name '_struct_gaze' num2str(gaze) '.mat'];

        mat=load(struct_path);
        struct=mat.matrix_in;

        mask=imread(masks_list{i});
        aoicoords=getaoicoords(mask,40,0);

        for c=1:length(channels)
            iFactor_channel_path=[mats_path '/' name '_iFactor_channel(' channels{c} ')_gaze' num2str(gaze) '.mat'];
            mat=load(iFactor_channel_path);
            iFactors{c}=mat.matrix_in;

            [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
            activity_mean_s{i}{c}=nanmean(activity_mean,2);
            activity_mean_o{i}{c}=nanmean(activity_mean,1);
            activity_mean_c{i}(1,c,:)=nanmean(nanmean(activity_mean,2),1);
            activity_mean_all{i}{c}=activity_mean;

            if ~isempty(aoicoords)
                [croppedmatrix,croppedmatrix_bg]=cropmat(iFactors{c},aoicoords(1),aoicoords(3),aoicoords(2),aoicoords(4)); 

                [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(croppedmatrix,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
                cropped_activity_mean_s{i}{c}=nanmean(activity_mean,2);
                cropped_activity_mean_o{i}{c}=nanmean(activity_mean,1);
                cropped_activity_mean_c{i}(1,c,:)=nanmean(nanmean(activity_mean,2),1);
                cropped_activity_mean_all{i}{c}=activity_mean;

                [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(croppedmatrix_bg,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
                cropped_bg_activity_mean_s{i}{c}=nanmean(activity_mean,2);
                cropped_bg_activity_mean_o{i}{c}=nanmean(activity_mean,1);
                cropped_bg_activity_mean_c{i}(1,c,:)=nanmean(nanmean(activity_mean,2),1);
                cropped_bg_activity_mean_all{i}{c}=activity_mean;

            else
                cropped_activity_mean_s{i}{c}=NaN.*ones(size(activity_mean_s{i}{c}));
                cropped_activity_mean_o{i}{c}=NaN.*ones(size(activity_mean_o{i}{c}));
                cropped_activity_mean_c{i}(1,c,:)=NaN.*ones(size(activity_mean_c{i}(1,c,:)));
                cropped_activity_mean_all{i}{c}=NaN.*ones(size(activity_mean_all{i}{c}));

                cropped_bg_activity_mean_s{i}{c}=NaN.*ones(size(activity_mean_s{i}{c}));
                cropped_bg_activity_mean_o{i}{c}=NaN.*ones(size(activity_mean_o{i}{c}));
                cropped_bg_activity_mean_c{i}(1,c,:)=NaN.*ones(size(activity_mean_c{i}(1,c,:)));
                cropped_bg_activity_mean_all{i}{c}=NaN.*ones(size(activity_mean_all{i}{c}));

            end
        end

    end


    %% dynamics for all tmem

    hold on;
    for c=1:length(images_list)
        dynamic=squeeze(nanmean(nanmean((cropped_activity_mean_all{c}{channel}(:,:,:))))); 
        %dynamic=squeeze(nanmean(nanmean((activity_mean_all{c}{channel}(:,:,:))))); 
        %dynamic=squeeze(nanmean(nanmean((cropped_bg_activity_mean_all{c}{channel}(:,:,:))))); 
        %dynamic=squeeze(activity_mean_all{c}{channel}(sfreq,orient,:)); 
        t=1:length(dynamic);
        plot(t,dynamic,'Color',colors(c,:));
            %phase plot
            %v=(gradient(dynamic)./gradient(t));
            %plot(dynamic,v);
            %plot(t(end),v(end,end),'x');
    end
    title(Title);
    legend(Legend);
    xlabel('# iter');
    ylabel('Firing Rate (spikes / s)');
    hold off;
    set(gcf,'units','points','position',[10,10,300,200]);
    savefig(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_all' '.fig']);
    fig2png(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_all' '.fig'],['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_all' '.png']);
    close all;

    %% dynamics for specific sfreq and orient
    for s=1:length(sfreq)
        ss=sfreq(s);
        for o=1:length(orient)
            oo=orient(o);
            hold on;
            for c=1:length(images_list)
                dynamic=squeeze(cropped_activity_mean_all{c}{channel}(ss,oo,:)); 
                %dynamic=squeeze(nanmean(activity_mean_all{c}{channel}(sfreq,:,:)));
                %dynamic=squeeze(cropped_bg_activity_mean_all{c}{channel}(sfreq,orient,:)); 
                t=1:length(dynamic);
                plot(t,dynamic,'Color',colors(c,:));
                    %phase plot
                    %v=(gradient(dynamic)./gradient(t));
                    %plot(dynamic,v);
                    %plot(t(end),v(end,end),'x');
            end
            title(Title);
            legend(Legend);
            xlabel('# iter');
            ylabel('Firing Rate (spikes / s)');
            hold off;
            set(gcf,'units','points','position',[10,10,300,200]);
            savefig(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_sfreq' int2str(ss) '_orient' int2str(oo) '.fig']);
            fig2png(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond)  '_sfreq' int2str(ss) '_orient' int2str(oo) '.fig'],['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_sfreq' int2str(ss) '_orient' int2str(oo) '.png']);
            close all;
        end
    end



    %% all freq, single orient
    for o=1:length(orient)
        oo=orient(o);

        hold on;
        for c=1:length(images_list)
            dynamic=squeeze(nanmean(cropped_activity_mean_all{c}{channel}(:,oo,:))); 
            t=1:length(dynamic);
            plot(t,dynamic,'Color',colors(c,:));
                %phase plot
                %v=(gradient(dynamic)./gradient(t));
                %plot(dynamic,v);
                %plot(t(end),v(end,end),'x');
        end
        title(Title);
        legend(Legend);
        xlabel('# iter');
        ylabel('Firing Rate (spikes / s)');
        hold off;
        set(gcf,'units','points','position',[10,10,300,200]);
        savefig(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_allfreq' '_orient' int2str(oo) '.fig']);
        fig2png(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_allfreq' '_orient' int2str(oo) '.fig'],['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_allfreq' '_orient' int2str(oo) '.png']);
        close all;
    end


    %% all orient, single freq
    for s=1:length(sfreq)
        ss=sfreq(s);
        hold on;
        for c=1:length(images_list)
            dynamic=squeeze(nanmean(cropped_activity_mean_all{c}{channel}(ss,:,:))); 
            t=1:length(dynamic);
            plot(t,dynamic,'Color',colors(c,:));
                %phase plot
                %v=(gradient(dynamic)./gradient(t));
                %plot(dynamic,v);
                %plot(t(end),v(end,end),'x');
        end
        title(Title);
        legend(Legend);
        xlabel('# iter');
        ylabel('Firing Rate (spikes / s)');
        hold off;
        set(gcf,'units','points','position',[10,10,300,200]);
        savefig(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_sfreq' int2str(ss) '_allorient' '.fig']);
        fig2png(['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond)  '_sfreq' int2str(ss) '_allorient' '.fig'],['figs/' '/' 'b' int2str(block) '_bc' int2str(block_cond) '_sfreq' int2str(ss) '_allorient' '.png']);
        close all;
    end

end



end

