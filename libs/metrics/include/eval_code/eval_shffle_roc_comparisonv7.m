function [meanroc seroc meanKL seKL mean_curve] = eval_shffle_roc_comparisonv7(process_mode, run_name, noTrials, center_sizes, surround_sizes,scale_f, csf_params)

roc = zeros(noTrials,1);
KLD = zeros(noTrials,1);
roc_curves = zeros(256,2,noTrials);
numImgs = 100;

load('idx_s');    

if strcmp(process_mode,'parallel')
    
    imgpath  = '/home/nmurray/MIT_eyetracking_dataset/eyetrackingdata/fixdens/Original Image Set';
    datapath = '/home/nmurray/MIT_eyetracking_dataset/sampledata/';
    outpath  = '/home/nmurray/MIT_eyetracking_dataset/sampledata/out_';
    seopath  = '/home/nmurray/Seo09_Pcode/Tsotsos_dataset_maps';
    mapspath = '/home/nmurray/MIT_eyetracking_dataset/CIWaM_salienc_opt/smaps/';

    jm = findResource('scheduler','type','jobmanager','Name','cluster','LookupURL','localhost');

    % Construct a job object with a specific name:
    job = createJob(jm);

    pathdps{1,1} = '/home/nmurray/MIT_eyetracking_dataset/CIWaM_salienc_opt';
    pathdps{1,2} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/';
    pathdps{1,3} = '/home/nmurray/MIT_eyetracking_dataset/JuddSaliencyModel';
    pathdps{1,4} = '/home/nmurray/MIT_eyetracking_dataset/JuddSaliencyModel/matlabPyrTools';
    pathdps{1,5} = '/home/nmurray/AIM';
    pathdps{1,6} = '/home/nmurray/MIT_eyetracking_dataset/CIWaM_salienc_opt/smaps/';
    
    set(job,'PathDependencies',pathdps);

    filedps{1,1} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/IDWD_Mallat.mexa64';
    filedps{1,2} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/DWD_Mallat.mexa64';
    filedps{1,3} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/ciwam_saliency_mex.mexa64';
    filedps{1,4} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/IDWD_Mallat_contrast.mexa64';
    filedps{1,5} = '/home/nmurray/MIT_eyetracking_dataset/Code/BIWaM/c++/matlab/DWD_Mallat_contrast.mexa64';
    set(job,'FileDependencies',filedps);

    % delete old smaps:
    system(['rm -f ' mapspath '*.mat']);    
    
    params{1,1} = process_mode;
    params{1,2} = imgpath;
    params{1,3} = seopath;
    params{1,4} = run_name;
    params{1,5} = datapath;
    params{1,7} = mapspath;
    params{1,8} = center_sizes;
    params{1,9} = surround_sizes;
    params{1,10} = scale_f;
    params{1,11} = csf_params;
    params{1,12} = numImgs;
    
    for k = 1:noTrials
        idx = randperm(numImgs);
        params{1,6} = idx;
        params{1,13} = k;
        
        % Add tasks to the job:
        t = createTask(job, @get_kl_roc, 3, {params});
    end

    % Run the job:
    submit(job);

    % Syncro parallel jobs:
    waitForState(job, 'finished');

    % Retrieve job results:
    out = getAllOutputArguments(job);

    for k=1:noTrials
        KLD(k) = out{k,1};
        roc(k) = out{k,2};
        roc_curves(:,:,k) = out{k,3};
    end
    meanroc = mean(roc);
    seroc   = std(roc)/sqrt(noTrials);
    meanKL  = mean(KLD);
    seKL    = std(KLD)/sqrt(noTrials);
    mean_curve = mean(roc_curves,3);
    
    save([outpath run_name '.mat'],'meanroc', 'seroc','meanKL','seKL', 'mean_curve');

    % Destroy the job.
    destroy(job);

else
    close all;
    addpath '/home/naila/Documents/Saliency_maps2/c++/matlab'
    addpath '/home/naila/Documents/MIT_eyetracking_dataset/JuddSaliencyModel'
    addpath '/home/naila/Documents/MIT_eyetracking_dataset/JuddSaliencyModel/matlabPyrTools'
    addpath '/home/naila/Documents/Saliency_maps3/matlab'
    addpath '/home/naila/Documents/AIM'

    imgpath  = '/home/naila/Documents/eyetrackingdata/fixdens/Original Image Set';
    datapath = '/home/naila/Documents/MIT_eyetracking_dataset/sampledata/';
    seopath  = '/home/naila/Documents/MIT_eyetracking_dataset/Tsotsos_dataset_maps';
    outpath  = '/home/naila/Documents/MIT_eyetracking_dataset/sampledata/out_';
    mapspath = '/home/naila/Documents/CIWaM_salienc_opt/smaps/';
    
    % delete old smaps:
    system(['rm ' mapspath '*.mat']);

    for k=1:noTrials
        idx = randperm(numImgs);
        while ~isempty(find(idx == 1:numImgs,1))
            idx = randperm(numImgs);
        end
        [KLD_k roc_i roc_curve] = get_kl_roc(process_mode, imgpath, seopath, run_name, datapath, idx, mapspath, center_sizes, surround_sizes, scale_f, csf_params, numImgs, k);
        KLD(k)        = KLD_k;
        roc(k)        = roc_i;
        roc_curves(:,:,k) = roc_curve;
    end
    meanroc = mean(roc);
    seroc   = std(roc)/sqrt(noTrials);
    meanKL  = mean(KLD);
    seKL    = std(KLD)/sqrt(noTrials);
    mean_curve = mean(roc_curves,3);
    
    save([outpath run_name '.mat'],'meanroc', 'seroc','meanKL','seKL', 'mean_curve');
end
end

function [KLD roc roc_curve] = get_kl_roc(process_mode, imgpath, seopath, run_name, datapath, idx, mapspath, center_sizes, surround_sizes,scale_f, csf_params, numImgs, k)

load rawfix_haejong

% get the distribution of real & shuffled fixations
sfixes=zeros(256,1);                 % distributions
sfixes_shuffle=zeros(256,1);         % distributions
for i = 1:numImgs
    gamma_flag = 'sRGB';
    filename   = [num2str(i+20) '.jpg'];
    img        = imread([imgpath '/' filename]);
    [m n p]    = size(img);
    ds         = 2;
    m_resiz    = round(m/(2.^ds));
    n_resiz    = round(n/(2.^ds));

    % generate test saliency maps:
    x     = 1;
    r     = 1600/19.86;
    d     = 0.75*39.3700787;
    ROI   = 50/(2.^ds)/r;
    v_ROI = atan(ROI/d);
    sthr  = log2(d*tan(v_ROI)/(1*(max([m_resiz n_resiz])/r)));
    ajust = [2 0 1 0 0];
    center_sizes   = round(ROI*r);
    surround_sizes = center_sizes*2;
    smap = get_ciwam_sal_map(imgpath,filename,sthr,x,gamma_flag,process_mode, ajust, center_sizes, surround_sizes, m_resiz, n_resiz, m, n, scale_f, csf_params);
    
    % get fixation map for this image:
    fixes=rawfix_haejong{i+20};
    
    if strcmp(process_mode,'serial2')
        s_img2 = load([seopath '/' num2str(i) 'mat.mat']);
        s_img2 = s_img2.smap;
        smap2  = floor(mat2gray(s_img2)*255);
        
        figure; set(gcf,'units','normalized','position',[0 0.5 4 2],'Visible','off','Renderer', 'painters');
        subplot(1,4,1); imshow(img); set(gca,'Position',[0.01 0.01 0.23 0.9]); hold on;
        plot(fixes(:,1),fixes(:,2),'y.','MarkerSize',8); %Plot all fixations (yellow dots)

        thres       = 0.1;
        thres_s     = round(thres*m*n);
        [smax sind] = sort(smap2(:),'descend');
        smap2_bin(sind(1:thres_s))       = 255;
        smap2_bin(sind(thres_s + 1:end)) = 0;
        smap2_bin                        = reshape(smap2_bin,[m,n]);

        smap3   = AIM([imgpath '/' filename],0.5);
        map_max = max(smap3(:));
        map_min = min(smap3(:));
        smap3   = 255*(smap3 - map_min)./(map_max - map_min);
        smap3   = imresize(smap3,[m n],'bilinear');
        
        [smax sind] = sort(smap3(:),'descend');
        smap3_bin   = smap3;
        smap3_bin(sind(1:thres_s))       = 255;
        smap3_bin(sind(thres_s + 1:end)) = 0;
        smap3_bin                        = reshape(smap3_bin,[m,n]);
        subplot(1,4,2); imshow(uint8(repmat(smap3,[1 1 3]))); set(gca,'Position',[0.26 0.01 0.23 0.9]); hold on;
        plot(fixes(:,1),fixes(:,2),'y.','MarkerSize',8);
        
        subplot(1,4,3); imshow(uint8(repmat(smap2,[1 1 3]))); set(gca,'Position',[0.51 0.01 0.23 0.9]); hold on;
        plot(fixes(:,1),fixes(:,2),'y.','MarkerSize',8);
        
       [smax sind] = sort(smap(:),'descend');
        smap_bin    = smap;
        smap_bin(sind(1:thres_s))       = 255;
        smap_bin(sind(thres_s + 1:end)) = 0;
        smap_bin                        = reshape(smap_bin,[m,n]);

        subplot(1,4,4); imshow(uint8(repmat(smap,[1 1 3]))); set(gca,'Position',[0.76 0.01 0.23 0.9]); hold on;
        plot(fixes(:,1),fixes(:,2),'y.','MarkerSize',8);
        print( gcf, '-djpeg', ['/home/naila/Documents/eyetrackingdata/ciwam_on_tsotsos/' filename(1:end-4) '_ciwam_bin']);
       close all;
    end
    
    % get fixation map for another random image:
    fixes_shuffle=rawfix_haejong{idx(i)+20};

    fixes=ceil(fixes/1);
    fixes_shuffle=ceil(fixes_shuffle/1);

    % create histogram of saliency values at fixated pts:
    for j=1:size(fixes,1)
        sfixes(smap(fixes(j,2),fixes(j,1))+1)=sfixes(smap(fixes(j,2),fixes(j,1))+1)+1;
    end

    % create histogram of saliency values at random fixated pts:
    for j=1:size(fixes_shuffle,1)
        sfixes_shuffle(smap(fixes_shuffle(j,2),fixes_shuffle(j,1))+1)=sfixes_shuffle(smap(fixes_shuffle(j,2),fixes_shuffle(j,1))+1)+1;
    end
end

% ROC curve:
thres=1:256;
FP=zeros(length(thres),1);
TP=zeros(length(thres),1);

% cumsum descending:
for i=1:length(thres)
    TP(i)=sum(sfixes(thres(i):end))/sum(sfixes);
    FP(i)=sum(sfixes_shuffle(thres(i):end))/sum(sfixes_shuffle);
end

% account for log(0) errors and change to probabilities:
sfixes1 = (sfixes+1)/sum(sfixes+1);
sfixes_shuffle1 = (sfixes_shuffle+1)/sum(sfixes_shuffle+1);

% KL divergence:
KLD = sum(sfixes_shuffle1.*log2((sfixes_shuffle1)./(sfixes1)));

% Area under ROC:
rocarea=0;
for i=1:length(thres)-1
    rocarea=rocarea+(FP(i)-FP(i+1))*(TP(i+1)+TP(i))/2;
end
roc=rocarea;
roc_curve = [TP FP];
end

