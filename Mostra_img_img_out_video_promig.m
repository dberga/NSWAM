function []=Mostra_img_img_out_video_promig(img,img_out,wsize)


niter=size(img,4)

			cut=zeros(size(img,2),niter);
			cut_out=zeros(size(img,2),niter);
			for ff=1:niter
				cut(:,ff)=img(round((size(img,2)/2)),:,1,ff);
				cut_out(:,ff)=img_out(round((size(img,2)/2)),:,1,ff);
				%figure;plot(cut(:,ff),'--b');hold on
				%    plot(cut_out(:,ff),'r');
			end
			% stimulus oscillation/central cell response
			q=[cut(round((size(img,2)/4)),:);cut_out(round((size(img,2)/2)),:)];	% Surround luminosity
			%                     q=[cut(round((size(img,2)/2)),:);cut_out(round((size(img,2)/2)),:)]; % RF luminosity
			window_size=wsize;
			h=ones(1,window_size)/window_size;
			w=imfilter(q(2,:),h,'symmetric');
			figure;plot((1:size(q,2)),q(1,:),'b');hold on
			plot((1:size(q,2)),q(2,:),'r');hold on
			plot((1:size(q,2)),w,'g','LineWidth',3)
			grid on;grid minor

			
			end