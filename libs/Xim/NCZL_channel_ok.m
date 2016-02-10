function [img_out] = NCZL_channel(img_in,struct,n,channel)

% img_in: monocromatic input image (i.e. one channel)

%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
wave=struct.wave;
comp=struct.compute;

% struct.zli
normal_output=zli.normal_output;

% struct.wave
multires=wave.multires;
n_scales=wave.n_scales;

% struct.compute
parallel=comp.parallel;
%-------------------------------------------------------


% scales we consider
ini_scale=3; % scale=1 es el pla de mes baixa frequencia. A partir de scale=2 van de alta frequencia a baixa
fin_scale=n_scales;

% En cas que la imatge sigui tota uniforme
if max(max(img_in))==min(min(img_in))
   img_out=img_in;
   return;
end

% image
img=double(img_in); % OP : necessari? ja és double no?

% wavelet decomposition +++++++++++++++++++++++++++++++++++++++++++++
switch (multires)
   case 'curv'
      curv = fdct_wrapping(img,1,1,n_scales);
   case 'a_trous'
      [w c] = a_trous(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'wav'
      [w c] = DWT(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'wav_contrast'
      [w c] = DWT_contrast(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'gabor'
		[curv,Ls]=GaborTransform_XOP(img,n_scales);
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
      return;
end
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% wavelet decomposition output
curv_final=curv;
iFactor=curv_final;  % ???-> Xavier


if(parallel==1)
    p={'/home/xotazu/neuro/olivier/ZLi_model_for_induction_minimal_implementation_31_1_2011'};
    jm=findResource('scheduler','type','jobmanager','Name','otazu','LookupURL','localhost');
    get(jm);
    job = createJob(jm);
    set(job,'FileDependencies',p)
    set(job,'PathDependencies',p)
	get(job)
end



for scale=ini_scale:fin_scale
	n_orient=size(curv{scale},2);
	disp(['scale: ' int2str(scale) ', n_orient: ' int2str(n_orient)])
    % parallel
    if(parallel==1)
        t=createTask(job, @NCZL_channel_orient, 1, {curv{scale},struct,n,scale});
    % no parallel
    else
        curv_final{scale}=NCZL_channel_orient(curv{scale},struct,n,scale);
    end
end


% parallel processing
if(parallel==1)
    submit(job)
    get(job,'Tasks')
    waitForState(job, 'finished');
	for i=ini_scale:n_scales
        job.Tasks(scale-ini_scale+1).ErrorMessage
    end
    out = getAllOutputArguments(job);
    for scale=ini_scale:n_scales
        n_orient=size(curv{scale},2);
        for orient=1:n_orient
             curv_final{scale}{orient}=out{scale-ini_scale+1}{orient}(1);
        end
    end
    destroy(job);
end


% e-CSF
for scale=ini_scale:n_scales
	n_orient=size(curv{scale},2);
   for i=1:n_orient
        curv_final{scale}{i}=curv_final{scale}{i}*normal_output;
   end
end


% inverse wavelet decomposition +++++++++++++++++++++++++++++++++++
switch (multires)
   case 'curv'
      img_out = ifdct_wrapping(curv_final,1,size(img_in,1),size(img_in,2));
   case 'a_trous'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = Ia_trous(w,c);
   case 'wav'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = IDWT(w,c,size(img,2), size(img,1));
   case 'wav_contrast'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = IDWT_contrast(w,c,size(img,2), size(img,1));
	case 'gabor'
		img_out=IGaborTransform_XOP(curv_final,n_scales,Ls);
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
   return;   
end
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end


 

