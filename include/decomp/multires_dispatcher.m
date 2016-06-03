function [curv w c Ls] = multires_dispatcher(img, method,n_scales ,n_membr)

    w = 0; %output of wavelets
    c = 0; %output of every method
    Ls = 0; %output of gabor methods
    curv=cell([n_membr,n_scales,1]);

   % number of wavelet decompositions to perform
   niter_wav=n_membr;
    
    % different wavelet decompositions		
    switch (method)
       case 'curv'
            for ff=1:niter_wav
                c = fdct_wrapping(img(:,:,ff),1,1,n_scales);
                for s=1:n_scales
                    n_orient=size(c{s},2);
                    for o=1:n_orient
                        curv{ff}{n_scales-s+1}{o}=c{s}{o};
                    end
                end
            end
       case 'a_trous'
            for ff=1:niter_wav  % note: that's for videos only

              [w c] = a_trous(img(:,:,ff), n_scales-1);
                for s=1:n_scales-1
                    for o=1:3
                        curv{ff}{s}{o}=w{s}(:,:,o);
                    end
                end
                curv{ff}{n_scales}{1}=c{n_scales-1};
            end
       case 'a_trous_contrast'
            for ff=1:niter_wav
              [w c] = a_trous_contrast(img(:,:,ff), n_scales-1);
                for s=1:n_scales-1
                    for o=1:3
                        curv{ff}{s}{o}=w{s}(:,:,o);
                    end
                end
                curv{ff}{n_scales}{1}=c{n_scales-1};
            end
       case 'wav'
            for ff=1:niter_wav
                [w c] = DWT(img(:,:,ff), n_scales-1);
                for s=1:n_scales-1
                    for o=1:3
                        curv{ff}{s}{o}=w{s}(:,:,o);
                    end
                end
                curv{ff}{n_scales}{1}=c{n_scales-1};
            end
       case 'wav_contrast'
            for ff=1:niter_wav
                [w c] = DWT_contrast(img(:,:,ff), n_scales-1);
                for s=1:n_scales-1
                    for o=1:3
                        curv{ff}{s}{o}=w{s}(:,:,o);
                    end
                end
                curv{ff}{n_scales}{1}=c{n_scales-1};
            end
       case 'gabor'
            for ff=1:niter_wav
                [curv{ff},Ls{ff}]=GaborTransform_XOP(img(:,:,ff),n_scales);
            end
             
       case 'gabor_HMAX'
    % 		for ff=1:niter_wav
                [curvGabor,n_scales]=Gabor_decomposition(img);
                disp(['gabor_HMAX n_scales:' int2str(n_scales)]);
    % 		end
            % we now have to transform the Gabor format into the curv format
            for ff=1:niter_wav

                for s=1:n_scales
                    for o=1:4
                        curv{ff}{s}{o}=curvGabor{ff}{s}{o};
                    end
                end
            end
       otherwise
          devlog('ERROR: No valid multiresolution decomposition method',4);
          return;
    end
    
    
    % induce artificila activity to a given neuron population (Rossi and Paradiso, 1999, Figure 2.3)
    % 	for s=1:n_scales
    % 		for o=1:size(curv{1}{s},2)
    % 			for ff=1:niter
    % 				curv{ff}{s}{o}(65,65)=0.2;
    % 			end
    % 		end
    % 	end
    

end