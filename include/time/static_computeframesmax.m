
%%%%%%%%%%%%%%%%%%%%other solution, using dimensional matrix (not cells)

function [img_out] = static_computeframesmax(img_in, n_membr, n_frames_promig)
    % take the mean (see Li, 1999)

	ff_ini=n_membr-n_frames_promig+1;
	ff_fin=n_membr;
	
	kk=max(img_in(:,:,:,ff_ini:ff_fin),4);
	%img_out=zeros(size(kk));
	img_out=kk;
end

