function [vec]=virtual_observer_func_parallel(x0, param)


% homexopdir='/home/xavier/neuro/olivier/ZLi_model_for_induction_minimal_implementation_31_1_2011/vd_3_6_2';
% 
% Comanda=sprintf('rm -f %s/stim*img %s/ind*img',homexopdir,homexopdir);
% system(Comanda)


more off

%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    1.8332    0.8614    0.4876    1.4836    3.8363]; % OK
%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    2.4332    0.8614    0.4876    1.4836    4.0000]; % OK sense fSigmaMax2Chrom

%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    2.4332    1.0614    0.8000	0.4876    1.4836    4.0000]; %OK
%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    3.4332    1.0614    0.5000	0.4876    0.4836    4.0000]; %OK pse
%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    3.4332    1.8614    0.5000	0.6876    0.8836    4.0000]; %OK hf, KO lf
%x0=[2.4582    0.9006    0.8222    0.5012    0.6672    0.5357    3.0332    1.8614    0.5000	0.6876    0.4836    4.0000]; % Ok

%x0=[2.614138 0.770737 0.899369 0.514613 0.583354 0.252329 3.576255 0.834825 0.743150 0.690500 0.500669 3.931081]; % No esta gens malament
%x0=[3.999754 1.179629 1.558333 0.518477 0.589140 0.039239 3.541234 0.357688 1.054835 1.528508 0.784509 4.998697];	% virtual observer 8 experim OK numeric, BAD contrast
%x0=[3.939022 1.526633 1.160991 0.936230 0.962031 0.162738 3.947664 0.567548 0.724953 1.033168 0.890329 4.985301]; % Ok virtual_observer
%x0=[3.939022 1.526633 1.160991 0.936230 0.962031 0.002738 3.947664 0.567548 0.824953 0.833168 0.890329 4.985301];	% OK virtual_observer retocat

f=fopen('intermig.dat','at');
fprintf(f,'Nova iter\n');
for i=1:size(x0,2)
    fprintf(f,'%f ',x0(i));
end
fprintf(f,'\n\n');
fclose(f);


   % Colors  LMS old


	
grey_lsY=[0.66 0.98 27.5];
grey_LMS=lsY2LMS(grey_lsY);


black_lsY=grey_lsY;
black_lsY(3)=0.;

% Shevell circles colors
test_yellow_blue_lsY=[0.66 0.98 27.5];
test_green_blue_lsY=[0.67 1 26];
test_green_magenta_lsY=[0.66 0.98 27.5];
test_yellow_magenta_lsY=[0.65 1 30];
% Contrast colors
test_blue_green_contrast_lsY=[0.64 1 26];
test_green_yellow_contrast_lsY=[0.66 0.6 34.5];
test_yellow_magenta_contrast_lsY=[0.68 1 29.5];
test_magenta_blue_contrast_lsY=[0.66 1.4 21];

test_shevell_lsY=[0.62 1 20];
purple_lsY=[0.66 2 15];
lime_lsY=[0.66 0.16 15];


blue_lsY=[0.64 1.4 20];
yellow_lsY=[0.68 0.6 37];
green_lsY=[0.64 0.6 32];
magenta_lsY=[0.68 1.4 22];


%     % Colors LMS new
% 
% grey_lsY=[0.659950 0.907590 27.577000];
% grey_LMS=lsY2LMS(grey_lsY);
% 
% % Shevell circles colors
% test_yellow_blue_lsY=[0.659950 0.907590 27.577000];
% test_green_blue_lsY=[0.669570 0.928590 25.983000];
% test_green_magenta_lsY=[0.659950 0.907590 27.577000];
% test_yellow_magenta_lsY=[0.650400 0.924170 30.184000];
% % Contrast colors
% test_blue_green_contrast_lsY=[0.640910	0.921990	26.247000];
% test_green_yellow_contrast_lsY=[0.659810 0.551100 34.634000];
% test_yellow_magenta_contrast_lsY=[0.679260 0.930820 29.380000];
% test_magenta_blue_contrast_lsY=[0.660100 1.302500 21.033000];
% 
% test_shevell_lsY=[0.622110	0.917660	20.326000];
% purple_lsY=[0.660320	1.868400	14.998000];
% lime_lsY=[0.659250 0.171300 15.124000];
% 
% 
% blue_lsY=[0.641030 1.295600 20.167000];
% yellow_lsY=[0.679090 0.552990 36.892000];
% green_lsY=[0.640780 0.549230 32.341000];
% magenta_lsY=[0.679430 1.309500 21.885000];



%     % Passar colors de lsY a LMS
% 
% grey_LMS=lsY2LMS(grey_lsY);
%     
% % Shevell circles colors
% test_yellow_blue_LMS=lsY2LMS(test_yellow_blue_lsY);
% test_green_blue_LMS=lsY2LMS(test_green_blue_lsY);
% test_green_magenta_LMS=lsY2LMS(test_green_magenta_lsY);
% test_yellow_magenta_LMS=lsY2LMS(test_yellow_magenta_lsY);
% % Contrast colors
% test_blue_green_LMS=lsY2LMS(test_blue_green_lsY);
% test_green_yellow_LMS=lsY2LMS(test_green_yellow_lsY);
% test_yellow_magenta_LMS=lsY2LMS(test_yellow_magenta_lsY);
% test_magenta_blue_LMS=lsY2LMS(test_magenta_blue_lsY);
% 
% 
% blue_LMS=lsY2LMS(blue_lsY);
% yellow_LMS=lsY2LMS(yellow_lsY);
% green_LMS=lsY2LMS(green_lsY);
% magenta_LMS=lsY2LMS(magenta_lsY);
% 
    

% ===================================
% DEFINICIO PARAMETRES METODE


experiment(1).nom='Shevell 1';
experiment(1).stim_lsY=test_shevell_lsY;
experiment(1).inductor_lsY=purple_lsY;
experiment(1).inductor_far_lsY=lime_lsY;
experiment(1).flag=1;

experiment(2).nom='Shevell 2';
experiment(2).stim_lsY=test_yellow_blue_lsY;
experiment(2).inductor_lsY=blue_lsY;
experiment(2).inductor_far_lsY=yellow_lsY;
experiment(2).flag=1;

experiment(3).nom='Shevell 3';
experiment(3).stim_lsY=test_green_blue_lsY;
experiment(3).inductor_lsY=blue_lsY;
experiment(3).inductor_far_lsY=green_lsY;
experiment(3).flag=1;

experiment(4).nom='Shevell 4';
experiment(4).stim_lsY=test_green_magenta_lsY;
experiment(4).inductor_lsY=magenta_lsY;
experiment(4).inductor_far_lsY=green_lsY;
experiment(4).flag=1;

experiment(5).nom='Shevell 5';
experiment(5).stim_lsY=test_yellow_magenta_lsY;
experiment(5).inductor_lsY=magenta_lsY;
experiment(5).inductor_far_lsY=yellow_lsY;
experiment(5).flag=1;

experiment(6).nom='Contrast 1';
experiment(6).stim_lsY=test_blue_green_contrast_lsY;
experiment(6).inductor_lsY=green_lsY;
experiment(6).inductor_far_lsY=green_lsY;
experiment(6).flag=1;

experiment(7).nom='Contrast 2';
experiment(7).stim_lsY=test_green_yellow_contrast_lsY;
experiment(7).inductor_lsY=yellow_lsY;
experiment(7).inductor_far_lsY=yellow_lsY;
experiment(7).flag=1;

experiment(8).nom='Contrast 3';
experiment(8).stim_lsY=test_yellow_magenta_contrast_lsY;
experiment(8).inductor_lsY=magenta_lsY;
experiment(8).inductor_far_lsY=magenta_lsY;
experiment(8).flag=1;

experiment(9).nom='Contrast 4';
experiment(9).stim_lsY=test_magenta_blue_contrast_lsY;
experiment(9).inductor_lsY=blue_lsY;
experiment(9).inductor_far_lsY=blue_lsY;
experiment(9).flag=1;


experiment(10).nom='Shevell2 2';
experiment(10).stim_lsY=test_yellow_blue_lsY;
experiment(10).inductor_lsY=yellow_lsY;
experiment(10).inductor_far_lsY=blue_lsY;
experiment(10).flag=1;

experiment(11).nom='Shevell2 3';
experiment(11).stim_lsY=test_green_blue_lsY;
experiment(11).inductor_lsY=green_lsY;
experiment(11).inductor_far_lsY=blue_lsY;
experiment(11).flag=1;

experiment(12).nom='Shevell2 4';
experiment(12).stim_lsY=test_green_magenta_lsY;
experiment(12).inductor_lsY=green_lsY;
experiment(12).inductor_far_lsY=magenta_lsY;
experiment(12).flag=1;

experiment(13).nom='Shevell2 5';
experiment(13).stim_lsY=test_yellow_magenta_lsY;
experiment(13).inductor_lsY=yellow_lsY;
experiment(13).inductor_far_lsY=magenta_lsY;
experiment(13).flag=1;

%experiment(7).flag=0;
%experiment(9).flag=0;


% nom_experim=['Shevell 1';'Shevell 2';'Shevell 3';'Shevell 4';'Shevell 5';'Contrast 1';'Contrast 2';'Contrast 3';'Contrast 4'];
% stim_lsY_experim=[test_shevell_lsY;test_yellow_blue_lsY;test_green_blue_lsY;test_green_magenta_lsY;test_yellow_magenta_lsY;test_blue_green_contrast_lsY;test_green_yellow_contrast_lsY;test_yellow_magenta_contrast_lsY;test_magenta_blue_contrast_lsY];
% inductor_lsY_experim=[purple_lsY blue_lsY;blue_lsY magenta_lsY;magenta_lsY;green_lsY;yellow_lsY;magenta_lsY blue_lsY];
% inductor_far_lsY_experim=[lime_lsY yellow_lsY green_lsY green_lsY yellow_lsY green_lsY yellow_lsY magenta_lsY blue_lsY];

% ===================================

f=fopen('masc_stim_11.img','rb');
masc_stim_11=fread(f,512*640,'single');
masc_stim_11=reshape(masc_stim_11, 512, 640);
fclose(f);

f=fopen('masc_test_11.img','rb');
masc_test_11=fread(f,512*640,'single');
masc_test_11=reshape(masc_test_11, 512, 640);
fclose(f);



iexperimseq=1;

% path(path,'/home/xavier/c++/matlab')

if(param.strct.compute.parallel==1)
 	jm=findResource('scheduler','type','jobmanager','Name',param.strct.compute.jobmanager,'LookupURL','localhost')

 	get(jm)
 
	% destroy any existing job
		
% 	jo= findJob(jm);
% 	destroy(jo);
	
 	% Construct a job object with a specific name.
 
 
	job = createJob(jm);
 	p=param.strct.compute.dir;
 	set(job,'FileDependencies',p);
 	set(job,'PathDependencies',p);
% 	path(path,'/home/xotazu/neuro/olivier/ZLi_model_for_induction_minimal_implementation_31_1_2011/vd_3_6_2')
% 	path(path,'/home/xotazu/c++/matlab')
	
 	get(job)
	
end



%for ipla=1:3
for ipla=3:3

%    placentral=placentral_experim(ipla)

%	placentral=param.placentral;

  
		iexperim_ini=2
		iexperim_fin=9
		  
%%		for iexperim=2:13
		for iexperim=iexperim_ini:iexperim_fin
%		for iexperim=2:5
%		for iexperim=2:2
% 			paramexp.x0superf=param.x0superf;
% 			paramexp.x0colorspace=param.x0colorspace;
			paramexp.x0=x0;
% 			paramexp.x_complementari=param.x_complementari;
			paramexp.experiment=experiment(iexperim);
			paramexp.iexperim=iexperim;
			paramexp.factor=param.factor;
			paramexp.masc_stim_11=masc_stim_11;
			paramexp.masc_test_11=masc_test_11;
			paramexp.ydata=param.ydata;
			paramexp.placentral=param.placentral;
			paramexp.strct=param.strct;
%			paramexp.homexopdir='/home/xavier/color/psycho';
		%	paramexp.error=param.error;

			
				% Add tasks to the job.
			if(param.strct.compute.parallel==1)
				t=createTask(job, @Experim_job, 1, {paramexp});

%			t=createTask(job, @rand, 1, {1});
% 			t=createTask(job, @prova_job, 1, {iexperim});
% 			t=createTask(job, @prova_job, 1, {paramexp});
		
				iexperim			
			else
				% Sequential
				out{iexperim-iexperim_ini+1}=Experim_job(paramexp);
			end
		end	% end iexperim
		
% 		
% 			% Run the job.		

			if(param.strct.compute.parallel==1)
				submit(job);
			end 
end % end pla

			if(param.strct.compute.parallel==1)
				get(job,'Tasks')
			end
 
 
 		% Sincro parallel jobs
		if(param.strct.compute.parallel==1)

			waitForState(job, 'finished')
			
% 			size(job.Tasks)
% 			job.Tasks
			for iexperim=1:iexperim_fin-iexperim_ini+1
				job.Tasks(iexperim).ErrorMessage
			end
			
			% Retrieve job results.
			out = getAllOutputArguments(job);
			
		end
		
	  out
	  
size(out)

			if(param.strct.compute.parallel==1)
				for iexperim=1:iexperim_fin-iexperim_ini+1
					job.Tasks(iexperim).ErrorMessage
				end
			end
			
			iexperimseq=1;
			for iexperim=1:iexperim_fin-iexperim_ini+1
				for istripe=1:3
					out{iexperim}.CIWaM_test_mind(iexperimseq,:)
					iexperimseq=iexperimseq+1
				end
			end


%     % Display the random matrix generated by one of the job's tasks.
%     disp(out{1});

		f=fopen('CIWaM_test_mind.dat','at');
		fprintf(f,'\n');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				fprintf(f,'%f %f %f\n', out{iexperim}.CIWaM_test_mind(iexperimseq,1), out{iexperim}.CIWaM_test_mind(iexperimseq,2), out{iexperim}.CIWaM_test_mind(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);

		f=fopen('stim_mind.dat','at');%system(Comanda)
		fprintf(f,'\n');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				fprintf(f,'%f %f %f\n',out{iexperim}.stim_mind(iexperimseq,1), out{iexperim}.stim_mind(iexperimseq,2), out{iexperim}.stim_mind(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);

		f=fopen('v.dat','at');
		fprintf(f,'\n');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				fprintf(f,'%f %f %f\n', out{iexperim}.v(iexperimseq,1), out{iexperim}.v(iexperimseq,2), out{iexperim}.v(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);

		nstripes=[5 11 17];
				
		f=fopen('Predictions_psycho.dat','at');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
			fprintf(f,'#\n#\t%s\n#\n',experiment(iexperim+1).nom);
 			for istripe=1:3
			fprintf(f,'# %d stripes\n%f %f %f\n',nstripes(istripe), out{iexperim}.test_lsY(iexperimseq,1), out{iexperim}.test_lsY(iexperimseq,2), out{iexperim}.test_lsY(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);

			
		f=fopen('Predictions_psycho_ultim.dat','at');
		fprintf(f,'\n');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				fprintf(f,'%f %f %f\n', out{iexperim}.test_lsY(iexperimseq,1), out{iexperim}.test_lsY(iexperimseq,2), out{iexperim}.test_lsY(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);


		f=fopen('v_rel.dat','at');
		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				fprintf(f,'%f %f %f\n', out{iexperim}.v_rel(iexperimseq,1), out{iexperim}.v_rel(iexperimseq,2), out{iexperim}.v_rel(iexperimseq,3));
				iexperimseq=iexperimseq+1;
			end
		end
		fclose(f);




     % Destroy the job.
    destroy(job);


		iexperimseq=1;
		for iexperim=1:iexperim_fin-iexperim_ini+1
 			for istripe=1:3
				vec(iexperimseq,:)= out{iexperim}.vec(iexperimseq,:);
				iexperimseq=iexperimseq+1;
			end
		end




vec

%vec=out.vec;


%var(v_lsY)



