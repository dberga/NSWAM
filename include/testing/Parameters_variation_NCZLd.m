clear variables;

strct=get_default_parameters_NCZLd();

% strct.image.single='mach';
% strct.image.single='che';
strct.image.single='whi';


strct2=strct;



niter=[2];
normal_input=[4];
normal_output=[2];
kappa1_factor=[1];
kappa2_factor=[1];
de_factor=[1];
di_factor=[1];
shift=[1];
fin_scale_offset=[1];

% % n_frames_promig: They depen on niter; see below

niter=[2];
normal_input=[4];
% normal_input=[1:0.2:4];
normal_output=[2];
% normal_output=[1.25:0.25:3];
kappa1_factor=[1];
kappa2_factor=[1];
de_factor=[1];
di_factor=[1];
shift=[1];
fin_scale_offset=[0 1];



size(niter,2)*size(normal_input,2)*size(normal_output,2)*size(kappa1_factor,2)*size(kappa2_factor,2)*size(de_factor,2)*size(di_factor,2)*size(shift,2)*size(fin_scale_offset,2)

img=get_the_stimulus(strct.image.single);

for i_niter=1:size(niter,2)
	strct2.zli_params.niter=niter(i_niter)
	n_frames_promig=[strct2.zli_params.niter];
	for i_normal_input=1:size(normal_input,2)
		strct2.zli_params.normal_input=normal_input(i_normal_input)
		for i_normal_output=1:size(normal_output,2)
			strct2.zli_params.normal_output=normal_output(i_normal_output)
			for i_kappa1_factor=1:size(kappa1_factor,2)
				strct2.zli_params.kappa1=strct.zli_params.kappa1*kappa1_factor(i_kappa1_factor)
				for i_kappa2_factor=1:size(kappa2_factor,2)
					strct2.zli_params.kappa2=strct.zli_params.kappa2*kappa2_factor(i_kappa2_factor)
					for i_de_factor=1:size(de_factor,2)
						strct2.zli_params.dedi(1,:)=strct.zli_params.dedi(1,:)*de_factor(i_de_factor)
						for i_di_factor=1:size(di_factor,2)
							strct2.zli_params.dedi(2,:)=strct.zli_params.dedi(2,:)*di_factor(i_di_factor)
							for i_shift=1:size(shift,2)
								strct2.zli_params.shift=shift(i_shift)
								for i_fin_scale_offset=1:size(fin_scale_offset,2)
									strct2.zli_params.fin_scale_offset=fin_scale_offset(i_fin_scale_offset)
									for i_n_frames_promig=1:size(n_frames_promig,2)
										strct2.image.n_frames_promig=n_frames_promig(i_n_frames_promig)
										
										[img_in,img_out]=NCZLd(img,strct2);
										nom_out=[strct2.image.single '_niter_' int2str(strct2.zli_params.niter) '_normal_in_' num2str(strct2.zli_params.normal_input) '_normal_out_' num2str(strct2.zli_params.normal_output) '_kappa1_' num2str(strct2.zli_params.kappa1(1)) '_kappa2_' num2str(strct2.zli_params.kappa2(1)) '_defactor_' num2str(de_factor(i_de_factor)) '_difactor_' num2str(di_factor(i_di_factor)) '_shift_' num2str(strct2.zli_params.shift) '_finscaleoff_' int2str(strct2.zli_params.fin_scale_offset) '_nfrpromig_' int2str(strct2.image.n_frames_promig) '.mat']
										save(nom_out,'img_out');
										
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

