function [out]=Experim_job(param)


%   xY=param.x0;
% 	xls=param.x_complementari;

	x0=param.x0;
	strct=param.strct;
	n_scales=strct.wave.n_scales;

	% Versio 1	
	strct.kappa1(1:n_scales)=x0(1)*ones(1,n_scales)/strct.compute.factor_kappa;
	strct.kappa2(1:n_scales)=x0(2)*ones(1,n_scales)/strct.compute.factor_kappa;
	strct.dedi(1,1:n_scales)=x0(3:3+n_scales-1);
	strct.dedi(2,1:n_scales)=x0(3+n_scales:3+n_scales+n_scales-1);

	
	% Versio 2	
% 	strct.kappa1(1:n_scales)=x0(1:n_scales)/strct.compute.factor_kappa;
% 	strct.kappa2(1:n_scales)=x0(n_scales+1:n_scales*2)/strct.compute.factor_kappa;
% 	strct.dedi(1,1:n_scales)=x0(n_scales*2+1)*ones(1,n_scales);
% 	strct.dedi(2,1:n_scales)=x0(n_scales*2+2)*ones(1,n_scales);

	strct.kappa1
	strct.kappa2
	strct.dedi

	more off
	
% 	homexopdir=param.homexopdir;


	experiment=param.experiment;
	iexperim=param.iexperim
%	factor=param.factor;
	masc_stim_11=param.masc_stim_11;
	masc_test_11=param.masc_test_11;
	ydata=param.ydata;
	placentral=param.placentral;

% cd(homexopdir)

%%%%%%% Calibracio global

ffactor1=param.factor(1);
ffactor2=param.factor(2);
ffactor3=param.factor(3);

factor=[ffactor1 ffactor2 ffactor3]

%inv_contrast=1./(max(fContrastMaxMaxChrom,fConstrastMaxMaxI)+0.1);
%inv_contrast=1./(max(x0(2:26))+0.1) * 0.85 % superficie samplejada

inv_contrast=1./(max(x0)+0.1) * 0.85 % VR
%inv_contrast=(min(x0)) * 0.6 % Divisive normalization
inv_contrast=[0.9 0.9 0.9];



grey_lsY=[0.66 0.98 27.5];
grey_LMS=lsY2LMS(grey_lsY);


black_lsY=grey_lsY;
black_lsY(3)=0.;


	if (experiment.flag==1)

		iexperimseq=(iexperim-2)*3+1
		% Dist minima entre colors finals
		col_min_dist_lsY=[0.0001 0.001 .05]; % OK
		%col_min_dist_lsY=[0.001 0.01 .2];
		%col_min_dist_lsY=[0.001 0.025 .5];
		col_min_dist_lsY=[0.005 0.05 .5];
% 		col_min_dist_lsY=[0.0005 0.01 .1];
% 		col_min_dist_lsY=[0.001 0.05 .1];
%		col_min_dist_lsY=[1 1 10];


		%contrastmaxim=1.0;

		nstripes_experim=[5 11 17];
		%erode_radi_experim=[5 2 2];
		nstripes_masc_experim=[9 21 25];
		placentral_experim=[4.357 3.357 2.357];

		experiment.nom
        
		stim_lsY=experiment.stim_lsY
		inductor_lsY=experiment.inductor_lsY
		inductor_far_lsY=experiment.inductor_far_lsY

%        f=fopen('Predictions_psycho.dat','at');
%        fprintf(f,'#\n#\t%s\n#\n',experiment(iexperim).nom);
%        fclose(f);
      

        
        
        for istripe=1:3

            nstripes=nstripes_experim(istripe)
%            erode_radi=erode_radi_experim(istripe)
            nstripes_masc=nstripes_masc_experim(istripe)

            stim_LMS=lsY2LMS(stim_lsY);
            inductor_LMS=lsY2LMS(inductor_lsY);
            inductor_far_LMS=lsY2LMS(inductor_far_lsY);

				
%				for nuvol=1:6
					
            test_lsY=stim_lsY;
            test_LMS=stim_LMS;

%           Inicialitzacio de les iteracions a partir dels valors psicofisics
           test_lsY=ydata(iexperimseq,:).*factor;

				
% 				switch nuvol
% 					case 1
% 						test_lsY(2)=test_lsY(2)+param.std_obsrv(iexperimseq,2);
% 					case 2
% 						test_lsY(1)=test_lsY(1)+param.std_obsrv(iexperimseq,1);
% 					case 3
% 						test_lsY(2)=test_lsY(2)-param.std_obsrv(iexperimseq,2);
% 					case 4
% 						test_lsY(1)=test_lsY(1)-param.std_obsrv(iexperimseq,1);
% 					case 5
% 						test_lsY(3)=test_lsY(3)-param.std_obsrv(iexperimseq,3);
% 					case 6
% 						test_lsY(3)=test_lsY(3)+param.std_obsrv(iexperimseq,3);
% 				end
				
				

                % Crear mascares anells

%             masc_stim=generate_colinduct_stim('shevell',[0 0 0],[0 0 0],[1 1 1],[0 0 0],nstripes,[0 0 0]);
%             masc_test=generate_colinduct_stim('shevell',[0 0 0],[0 0 0],[0 0 0],[1 1 1],nstripes,[0 0 0]);


%           erel=strel('disk',2);
%           save erel

            if  nstripes==11
                masc_stim=cat(3, masc_stim_11,masc_stim_11,masc_stim_11);
                masc_test=cat(3, masc_test_11,masc_test_11,masc_test_11);
            else            
                masc_stim=generate_colinduct_stim('shevell',[0 0 0],[0 0 0],[1 1 1],[0 0 0],nstripes_masc,[0 0 0],[0 0 0]);
                masc_test=generate_colinduct_stim('shevell',[0 0 0],[0 0 0],[0 0 0],[1 1 1],nstripes_masc,[0 0 0],[0 0 0]);
%                 masc_stim=imerode(masc_stim,erel);
%                 masc_test=imerode(masc_test,erel);
            end

% 
%             save masc_stim
%             save masc_test
%            figure,imshow(erel);
%            figure,imshow(masc_stim);
%            figure,imshow(masc_test);
            
            %masc_test(:,1:end/2,:)=0;



            % Calcular vector v de diferencia entre colors
            v_lsY=col_min_dist_lsY+.1;
				conv_sign=1


            % Si v < vmin llavors acabar, sino canviar color anell aplicant v/2 i iterar

            while( abs(v_lsY(1)*inv_contrast(1)) > col_min_dist_lsY(1) || abs(v_lsY(2)*inv_contrast(2)) > col_min_dist_lsY(2) || abs(v_lsY(3)*inv_contrast(3)) > col_min_dist_lsY(3) )


%					while( abs(v_lsY(1)) > col_min_dist_lsY(1) || abs(v_lsY(2)) > col_min_dist_lsY(2) )

                test_lsY
                % Crear imatge

                % LMS
            %    pic_stim=generate_colinduct_stim('shevell',inductor_LMS,inductor_far_LMS,stim_LMS,test_LMS,nstripes,grey_LMS);
                % lsY
                pic_stim=generate_colinduct_stim('shevell',inductor_lsY,inductor_far_lsY,stim_lsY,test_lsY,nstripes,grey_lsY,black_lsY);

%					imshow(pic_stim);
                alcada=size(pic_stim,1);
                amplada=size(pic_stim,2);

                %figure,imshow(pic_stim/255);


                % Guardar imatge en disc
					 
% % 					 Lexema=sprintf('%s/stim_%d_%d_',homexopdir,iexperim,istripe);
% 					 Lexema=sprintf('stim_%d_%d_',iexperim,istripe);
% 
%                 EscriuRGB2BINReal(pic_stim,Lexema);
% 					 
% 					 stim1=sprintf('%s',Lexema,'1.img');
% 					 stim2=sprintf('%s',Lexema,'2.img');
% 					 stim3=sprintf('%s',Lexema,'3.img');
% 
% % 					 LexemaInd=sprintf('%s/ind_%d_%d_',homexopdir,iexperim,istripe);
% 					 LexemaInd=sprintf('ind_%d_%d_',iexperim,istripe);
% 
% 					 ind1=sprintf('%s',LexemaInd,'1.img');
% 					 ind2=sprintf('%s',LexemaInd,'2.img');
% 					 ind3=sprintf('%s',LexemaInd,'3.img');
% 
% 					comanda=sprintf('chmod a+rwx %s %s %s;chown xavier:xavier %s %s %s',stim1,stim2,stim3,stim1,stim2,stim3);
% 					system(comanda)

                % Executar induccio

% 					 Comanda=sprintf('cpuset -l 2-3 nice ../Maria/ciwam_thread_HDR %d %d   %s %s %s   %s %s %s    2 0 0 0 %f 1 1 0 		3 6	%f %f %f %f %f %f     %f %f %f %f %f %f     %f %f %f %f %f %f		%f %f %d  		%f %f %f %f %f %f     %f %f %f %f %f %f     %f %f %f %f %f %f		%f %f %d			0 1.000000 0.000000 0.000000 0.000000 1.000000 0.000000 0.000000 0.000000 1.000000 0.660000 0.980000 27.500000 0.040000 0.766000 10.500000 0 0',amplada,alcada,stim3, stim1, stim2, ind3, ind1, ind2,placentral, xY(1),xY(2),xY(3),xY(4),xY(5),xY(6),xY(7),xY(8),xY(9),xY(10),xY(11),xY(12),xY(13),xY(14),xY(15),xY(16),xY(17),xY(18),xY(19),xY(20),4, xls(1),xls(2),xls(3),xls(4),xls(5),xls(6),xls(7),xls(8),xls(9),xls(10),xls(11),xls(12),xls(13),xls(14),xls(15),xls(16),xls(17),xls(18),xls(19),xls(20),4) %, bCanviEspai, fmatCanvi11, fmatCanvi12, fmatCanvi13, fmatCanvi21, fmatCanvi22, fmatCanvi23, fmatCanvi31, fmatCanvi32, fmatCanvi33, fmatCanvi41, fmatCanvi42, fmatCanvi43, ffactor1, ffactor2, ffactor3)
% 					 system(Comanda)


						%%%%%%%%%%%%%%%%%%%%%%%%%%%
						%%%%%% La passem a BN !!!!!
						%%%%%%%%%%%%%%%%%%%%%%%%%%%
						
						stimuli_tmp(:,:,1)=pic_stim(:,:,1)*0;
						stimuli_tmp(:,:,2)=pic_stim(:,:,2)*0;
						stimuli_tmp(:,:,3)=pic_stim(:,:,3);
						
						stimuli(:,:,1)=imresize(stimuli_tmp(:,:,1),size(stimuli_tmp(:,:,1))/2);
						stimuli(:,:,2)=imresize(stimuli_tmp(:,:,2),size(stimuli_tmp(:,:,2))/2);
						stimuli(:,:,3)=imresize(stimuli_tmp(:,:,3),size(stimuli_tmp(:,:,3))/2);
						
						size(stimuli)

						
						
						[kk, img_out]=NCZLd(stimuli, strct);

						
						img_out_tmp(:,:,1)=imresize(img_out(:,:,1),size(pic_stim(:,:,1)));
						img_out_tmp(:,:,2)=imresize(img_out(:,:,2),size(pic_stim(:,:,2)));
						img_out_tmp(:,:,3)=imresize(img_out(:,:,3),size(pic_stim(:,:,3)));
						
						l=pic_stim(:,:,1);
						s=pic_stim(:,:,2);
						Y=img_out_tmp(:,:,3);

                lsY= cat(3, l, s, Y);


                % Aplicar mascara i calcular colors mitjos

                % LMS
            %     stim_mig=sum(sum(LMS.*masc_stim,1),2)./sum(sum(masc_stim==1,1),2);
            %     test_mig=sum(sum(LMS.*masc_test,1),2)./sum(sum(masc_test==1,1),2);

                % lsY
                stim_mig=sum(sum(lsY.*masc_stim,1),2)./sum(sum(masc_stim==1,1),2);
                test_mig=sum(sum(lsY.*masc_test,1),2)./sum(sum(masc_test==1,1),2);



            %    % LMS
            %    stim_mig_LMS=[stim_mig(1) stim_mig(2) stim_mig(3)];
            %    test_mig_LMS=[test_mig(1) test_mig(2) test_mig(3)];
            %    stim_mig_lsY=LMS2lsY(stim_mig_LMS)
            %    test_mig_lsY=LMS2lsY(test_mig_LMS)

                % lsY
                stim_mig_lsY=[stim_mig(1) stim_mig(2) stim_mig(3)]
                test_mig_lsY=[test_mig(1) test_mig(2) test_mig(3)]


                % Calcular vector v de diferencia entre colors

                % LMS
            %    v_LMS=stim_mig_LMS-test_mig_LMS
                % lsY
                v_lsY=stim_mig_lsY-test_mig_lsY


						% Canvi de rate de convergencia
						
						condicio=(conv_sign~=sign(v_lsY));
						inv_contrast=inv_contrast-condicio*(1.0-0.9)
						conv_sign=sign(v_lsY)


	% ATENCIO !!!!!!
	
	v_lsY(1)=0.;
	v_lsY(2)=0.;
%	v_lsY(3)=0.;

					 
                 stdev=sqrt(sum(sum((lsY.*masc_test-ydata(iexperimseq)).^2,1),2))./sum(sum(masc_test==1,1),2)
					 
					 
                % Desplacar color test

                % LMS
            %     test_LMS=test_LMS + v_LMS.*0.75
            %     test_lsY=LMS2lsY(test_LMS)
                % lsY

					 test_lsY=test_lsY + v_lsY.*inv_contrast
					 % Direct samplling
%					 test_lsY=test_lsY + v_lsY.*0.6


           end % while

            % Mostrar/guardar resultats
				
				out.CIWaM_test_mind(iexperimseq,:)=test_mig_lsY(:);
				out.stim_mind(iexperimseq,:)=stim_mig_lsY(:);
				out.v(iexperimseq,:)=v_lsY(:);
				out.test_lsY(iexperimseq,:)=test_lsY(:);
				out.v_rel(iexperimseq,:)=v_lsY(:)./test_lsY(:);

				
%				end % for nuvol
%				if(param.error=='stdev')
%					out.vec(iexperimseq,:)=[stdev(1)/ffactor1 stdev(2)/ffactor2 stdev(3)/ffactor3]
%					out.vec(iexperimseq,:)=[stdev(1)/ffactor1 stdev(2)/ffactor2 ydata(iexperimseq,3)]
%					out.vec(iexperimseq,:)=[ydata(iexperimseq,1) ydata(iexperimseq,2) stdev(3)/ffactor3]
%				else
%					out.vec(iexperimseq,:)=[test_lsY(1)/ffactor1 test_lsY(2)/ffactor2 test_lsY(3)/ffactor3]
%					out.vec(iexperimseq,:)=[test_lsY(1)/ffactor1 test_lsY(2)/ffactor2 ydata(iexperimseq,3)]
					out.vec(iexperimseq,:)=[ydata(iexperimseq,1) ydata(iexperimseq,2) test_lsY(3)/ffactor3]
%				end
				iexperimseq=iexperimseq+1
				
		  end	% end stripe

	else
		out.vec(iexperimseq,:)=[ydata(experimseq,1) ydata(experimseq,2) ydata(experimseq,3)]
		iexperimseq=iexperimseq+1;
		out.vec(iexperimseq,:)=[ydata(experimseq,1) ydata(experimseq,2) ydata(experimseq,3)]
		iexperimseq=iexperimseq+1;
		out.vec(iexperimseq,:)=[ydata(experimseq,1) ydata(experimseq,2) ydata(experimseq,3)]
		iexperimseq=iexperimseq+1;
	
	end	%end if flag
	
	
