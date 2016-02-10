% figure PLOS one
% chevreul

% chevreul
load('che_256_min_freq_32_epsilon_1.3_kappay_1.25_normal_output_2_img.mat')
load('che_256_min_freq_32_epsilon_1.3_kappay_1.25_normal_output_2_img_out.mat')
% input
img1=img;
% take the mean of the output
img_out1=mean(img_out(:,:,:,4:end),4);



if 1==1
    figure
    subplot(1,2,1)
        imshow(uint8(img1));
        h1=title('Visual stimulus');set(h1,'FontName','Arial','FontWeight','Bold','FontSize',16)
        text(1, 1  , 'A', 'Color', 'k','FontName','Arial','FontWeight','Bold','FontSize',16);
        
    subplot(1,2,2)
        plot(img1(round((size(img_out1,2)/2)),:,1),'--k')
        hold on
%         plot(img1(100,:,1),'k')
%         hold on
        plot(img_out1(round((size(img_out1,2)/2)),:,1),'r')
        %xlim([1,255])
        h2=xlabel('# image column','FontName','Arial');
        set(h2,'FontName','Arial','FontWeight','Normal','FontSize',12)
        h3=ylabel('Brightness (arbitrary units)','FontName','Arial')
        set(h3,'FontName','Arial','FontWeight','Normal','FontSize',12)
        h4=title('Predicted brightness')
        set(h4,'FontName','Arial','FontWeight','Bold','FontSize',16)
         %h5=legend('Visual stimulus','Upper and lower sinusoidal stripes','Predicted brightness');
         %h5=legend('Luminance of the central stripe','Upper and lower sinusoidal stripes','Predicted brightness');
          h5=legend('luminance','predicted brightness');
     set(h5,'FontName','Arial','FontWeight','Normal','FontSize',14,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1])
         text(1, 1  , 'B', 'Color', 'k','FontName','Arial','FontWeight','Bold','FontSize',16);
         xlim([15,375])
          ylim([25,225])
         set(gca,'FontName','Arial')
end


% % data
% vec_in1=img1(round((size(img1,2)/2)),:,1);    
% vec_in2=img1(100,:,1);
% vec_out1= img_out1(round((size(img_out1,2)/2)),:,1);  
% cdata1=uint8(img1);
% YMatrix1=[vec_in1;vec_in2;vec_out1]';
% 
% createfigure_GI(cdata1, YMatrix1)


% 
% % legend more than one line
% figure; plot(sin(1:10),'b')
% hold on
% plot(cos(1:10),'r')
% legend({['blue' char(10) 'line'],'red line'})