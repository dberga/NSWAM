function z=analysis_plot_phase2(n,startn)


if strcmp(n,'todorovic')
    origpath='/home/penacchio/Documents/a code/1112_induction/todorovic';
    img=imread('Todorovic_effect_pattern_T.ppm');
elseif strcmp(n,'todorovic2')
    origpath='/home/penacchio/Documents/a code/1112_induction/todorovic2'; % Delta=40
    img=imread('Todorovic_effect_pattern_T.ppm');
elseif strcmp(n,'tod')
    origpath='/home/penacchio/Documents/a code/1112_induction/tod30'; % Delta=40
    img=imread('Todorovic_effect_pattern_T_512.ppm');    
elseif strcmp(n,'chevreul')    
    origpath='/home/penacchio/Documents/a code/1112_induction/chevreul';
    img=imread('Chevreul_pattern.ppm');
elseif strcmp(n,'chevreul2')    
    origpath='/home/penacchio/Documents/a code/1112_induction/chevreul2'; % Delta=20
    img=imread('Chevreul_pattern.ppm');   
elseif strcmp(n,'chevreul3')    
    origpath='/home/penacchio/Documents/a code/1112_induction/chevreul3'; % Delta=40
    img=imread('Chevreul_pattern.ppm');      
elseif strcmp(n,'white_256')    
    origpath='/home/penacchio/Documents/a code/1112_induction/white_256'; 
    img=imread('White_effect_pattern_W2_256.ppm');
elseif strcmp(n,'white_256_2')    
    origpath='/home/penacchio/Documents/a code/1112_induction/white_256_2';  % Delta=30
    img=imread('White_effect_pattern_W2_256.ppm');    
elseif strcmp(n,'white')    
    origpath='/home/penacchio/Documents/a code/1112_induction/white'; 
    img=imread('White_effect_pattern_W2.ppm');    
elseif strcmp(n,'three')
    origpath='/home/penacchio/Documents/a code/1112_induction/white'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul';
    img3=imread('Chevreul_pattern.ppm');
elseif strcmp(n,'three2')
    origpath='/home/penacchio/Documents/a code/1112_induction/white2'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic2';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul2';
    img3=imread('Chevreul_pattern.ppm');  
elseif strcmp(n,'three3')
    origpath='/home/penacchio/Documents/a code/1112_induction/white3'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic3';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul3';
    img3=imread('Chevreul_pattern.ppm'); 
elseif strcmp(n,'three01')
    origpath='/home/penacchio/Documents/a code/1112_induction/white01'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic01';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul01';
    img3=imread('Chevreul_pattern.ppm'); 
elseif strcmp(n,'three02')
    origpath='/home/penacchio/Documents/a code/1112_induction/white02'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic02';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul02';
    img3=imread('Chevreul_pattern.ppm'); 
elseif strcmp(n,'three03')
    origpath='/home/penacchio/Documents/a code/1112_induction/white03'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic03';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul03';
    img3=imread('Chevreul_pattern.ppm');
elseif strcmp(n,'three04')
    origpath='/home/penacchio/Documents/a code/1112_induction/white04'; 
    img1=imread('White_effect_pattern_W2_256.ppm');  
    origpath2='/home/penacchio/Documents/a code/1112_induction/todorovic04';
    img2=imread('Todorovic_effect_pattern_T_256.ppm');
    origpath3='/home/penacchio/Documents/a code/1112_induction/chevreul04';
    img3=imread('Chevreul_pattern.ppm');    
end    
    
imagefiles1=dir(fullfile(origpath,'*.mat'));
imagefiles2=dir(fullfile(origpath2,'*.mat'));
imagefiles3=dir(fullfile(origpath3,'*.mat'));
imagefileslength1=length(imagefiles1);    

screen_size = get(0, 'ScreenSize');
    
% startn=1;
for i=startn:imagefileslength1
        display(['Processing image ' imagefiles1(i,1).name])
        % 1
        origpath1=origpath;
        testpic1= fullfile(origpath1,imagefiles1(i,1).name);
        load(testpic1);
         %img_out=double(imread(testpic));
        imageoutname1=testpic1;
        %figure('Name',imageoutname1)
        img_out1=img_out;
        % 2
        testpic2= fullfile(origpath2,imagefiles2(i,1).name);
        load(testpic2);
         %img_out=double(imread(testpic));
        imageoutname2=testpic2;
        %figure('Name',imageoutname2)
        img_out2=img_out;
        % 3
        testpic3= fullfile(origpath3,imagefiles3(i,1).name);
        load(testpic3);
         %img_out=double(imread(testpic));
        imageoutname3=testpic3;
        %figure('Name',imageoutname3)
        img_out3=img_out;
        

        %plot(img(round((size(img,2)/2)),:,1),'--b');hold on
        %plot(img_out(round((size(img_out,2)/2)),:,1),'r');
        %ylim([0,350]);
        
        %%%
        figure('Name',imageoutname1)
        subplot(1,3,1),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
        plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
        ylim([0,350]);
        %%%
        subplot(1,3,2),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
        plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
        ylim([0,350]);
        %%%
        subplot(1,3,3),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
        plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
        ylim([0,350]);
        
        %f1 = figure(1);
        f1=gcf;
        set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
        
        ginput(1)
        
end

z=1;
end