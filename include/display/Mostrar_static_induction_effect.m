function []=Mostrar_static_induction_effect(img,img_out_all)

img_out=mean(img_out_all(:,:,:,4:end),4);
%img_out=img_out_all;

reduced=0;
                        % get the name
                        %str_delta=num2str(zli.Delta);
%                         n=1;
%                         str_n=num2str(n);
%                         str_de1=num2str(zli.dedi(1,1,n)); % 1,1,n for excitation, scale 1, nth parameters in the list 
%                         str_di1=num2str(zli.dedi(2,1,n)); 
%                         str_de2=num2str(zli.dedi(1,2,n)); 
%                         str_di2=num2str(zli.dedi(2,2,n)); 
%                         str_de3=num2str(zli.dedi(1,3,n)); 
%                         str_di3=num2str(zli.dedi(2,3,n)); 
%                         imageoutname=strcat(name,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
%                                                 '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                        
 
%figure('Name',imageoutname)
if reduced==0
figure
                            subplot(3,1,1),imshow(uint8(img));h=title('Visual stimulus');set(h,'FontSize',16);
							subplot(3,1,2),imshow(uint8(img_out));h=title('Predicted brightness');set(h,'FontSize',16);
                            subplot(3,1,3),plot(img(round((size(img,2)/2)),:,1),'--b');hold on
                            plot(img_out(round((size(img_out,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
									 hold off;
elseif reduced==1
   figure
                            %subplot(3,1,1),imshow(uint8(img));h=title('Visual stimulus');set(h,'FontSize',16);
							%subplot(3,1,2),imshow(uint8(img_out));h=title('Predicted brightness');set(h,'FontSize',16);
                            %subplot(3,1,3),
                            %plot(img(round((size(img,2)/2)),:,1),'--b');hold on
                            plot(img(round(151),:,1),'--b');hold on
                            %plot(img_out(round((size(img_out,2)/2)),:,1),'r');
                            plot(img_out(round((151)),:,1),'r');
                            
                            h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
									 hold off; 
                                     

end    
    
    
end                                     
                    