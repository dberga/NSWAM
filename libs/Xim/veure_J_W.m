function veure_J_W(J,W,K)

scale=size(J,1);
% scale=3;

f_J=figure;
f_W=figure;


	sp=1;
	for oc=1:K
		for ov=1:K
			figure(f_J),subplot(K,K,sp),imagesc(J{scale}(:,:,ov,oc));colormap('gray');
			figure(f_W),subplot(K,K,sp),imagesc(W{scale}(:,:,ov,oc));colormap('gray');
			sp=sp+1;
		end
	end

end