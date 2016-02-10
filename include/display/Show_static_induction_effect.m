function []=Show_static_induction_effect(img,img_out_all)

% show the output of general_NCZLd.m for static stimuli


img_out=mean(img_out_all(:,:,:,4:end),4);
%img_out=img_out_all;

reduced=1;
                   
if reduced==0
    figure
        subplot(3,1,1),imshow(uint8(img));h=title('Visual stimulus');set(h,'FontSize',16);
        subplot(3,1,2),imshow(uint8(img_out));h=title('Predicted brightness');set(h,'FontSize',16);
        subplot(3,1,3),plot(img(round((size(img,2)/2)),:,1),'--b');hold on
        plot(img_out(round((size(img_out,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
        hold off;
elseif reduced==1
    figure
        plot(img(round(151),:,1),'--b');hold on
        plot(img_out(round((151)),:,1),'r');
        h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
        hold off;
end
    
    
end                                     
                    