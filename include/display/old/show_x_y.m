function []=show_x_y(fig,x,y,I_norm,Iitheta,n_scales)

			for s=1:min(3,n_scales)
				for o=1:3
					figure(fig(s,o));subplot(2,3,1),imagesc(x(:,:,s,o));colormap('gray');title('x');
					figure(fig(s,o));subplot(2,3,2),imagesc(y(:,:,s,o));colormap('gray');title('y');
					figure(fig(s,o));subplot(2,3,4),imagesc(newgx(x(:,:,s,o)),[0 1]);colormap('gray');title('newg_x');
					figure(fig(s,o));subplot(2,3,5),imagesc(newgy(y(:,:,s,o)),[0 1]);colormap('gray');title('newg_y');
					figure(fig(s,o));subplot(2,3,3),imagesc(I_norm(:,:,s,o));title('I_norm');colormap('gray');
					figure(fig(s,o));subplot(2,3,6),imagesc(Iitheta(:,:,s,o));title('curv');colormap('gray');
				end
			end
end