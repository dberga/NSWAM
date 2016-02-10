function [tmp2,name]=get_the_stimulus(M,gamma,srgb_flag)


if strcmp(M,'mach')
    tmp=imread('Mach_OP.ppm');
    name='Mach_OP';
elseif strcmp(M,'grating5')
    tmp=imread('grating5.ppm');
    name='grating5'; 
elseif strcmp(M,'grating10')
    tmp=imread('grating10.ppm');
    name='grating10'; 
elseif strcmp(M,'natural128')
    tmp=imread('natural128.ppm');
    name='natural128';   
elseif strcmp(M,'branches128')
    tmp=imread('branches128.ppm');
    name='branches128';       
%------------------------------------------    
elseif strcmp(M,'mach_64')
    tmp=imread('Mach_OP_64.ppm');
    name='Mach_OP_64';
elseif strcmp(M,'mach_256')
    tmp=imread('Mach_OP.ppm');
    name='Mach_256'; 
elseif strcmp(M,'mach_128')
    tmp=imread('Mach_OP_128.ppm');
    name='Mach_128';      
elseif strcmp(M,'cameraman_64')
    tmp1=imread('cameraman.tif');
	 tmp=tmp1(1:4:256,1:4:256);
    name='cameraman_64';
elseif strcmp(M,'cameraman_128')
    tmp1=imread('cameraman.tif');
	 tmp=tmp1(1:2:256,1:2:256);
    name='cameraman_128';
elseif strcmp(M,'concord_256')
    tmp1=imread('concordorthophoto.png');
	 tmp=tmp1(1:16:2215,1:16:2956);
    name='concord_256';
elseif strcmp(M,'concord_512')
    tmp1=imread('concordorthophoto.png');
	 tmp=tmp1(1:8:2215,1:8:2956);
    name='concord_512';

elseif strcmp(M,'line_circle_128')
    tmp=imread('line_circle_128.ppm');
    name='line_circle_128';

elseif strcmp(M,'SBC1_256')
    tmp=imread('SBC_effect_pattern_SBC1_256.ppm');
    name='SBC_effect_pattern_SBC1_256';

elseif strcmp(M,'SBC3_256')
    tmp=imread('SBC_effect_pattern_SBC3_256.ppm');
    name='SBC_effect_pattern_SBC3_256';
	 
elseif strcmp(M,'che')
    tmp=imread('Chevreul_pattern.ppm');
    name='Chevreul_pattern';
elseif strcmp(M,'che_256')
    tmp=imread('Chevreul_pattern.ppm');
    name='Chevreul_pattern_240_400';
elseif strcmp(M,'che_128')
    tmp=imread('Chevreul_pattern_128.ppm');
    name='Chevreul_pattern_128';

elseif strcmp(M,'todo')
    tmp=imread('Todorovic_marc_ok.ppm');
    name='Todorovic';

elseif strcmp(M,'todo_128')
    tmp=imread('Todorovic_effect_pattern_T_128.ppm');
    name='Todorovic_128';
	 
elseif strcmp(M,'todo_256')
    tmp=imread('Todorovic_effect_pattern_T_256.ppm');
    name='Todorovic_256';
	 
elseif strcmp(M,'grating')
    tmp=imread('Grating_marc_ok.ppm');
    name='grating';
	 
elseif strcmp(M,'grating_128')
    tmp=imread('Grating_induction_128.ppm');
    name='grating_128';

elseif strcmp(M,'grating_256')
    tmp=imread('Grating_marc_ok_256.ppm');
    name='grating_256';

elseif strcmp(M,'whi')
    tmp=imread('White_effect_pattern_W2_256.ppm');
	 name='White_effect_pattern_W2_256';
     
elseif strcmp(M,'whi_256')
    tmp=imread('White_effect_pattern_W2_256.ppm');
	 name='White_effect_pattern_W2_256';
     
elseif strcmp(M,'whi_512')
    tmp=imread('White_effect_pattern_W2_512.ppm');
	 name='White_effect_pattern_W2_512';       

elseif strcmp(M,'whi_128')
    tmp=imread('White_effect_pattern_W2_128.ppm');
	 name='White_effect_pattern_W2_128';

elseif strcmp(M,'whi_64')
    tmp=imread('White_effect_pattern_W2_64.ppm');
	 name='White_effect_pattern_W2_64';

elseif strcmp(M,'whi_swirl_petit')
    tmp=imread('F12.large_retall_256.ppm');
    name='F12.large_retall_256';
	 
elseif strcmp(M,'whi_swirl')
    tmp=imread('F12.large_retall.ppm');
    name='F12.large_retall';
	 
elseif strcmp(M,'whi_new50')
    tmp=imread('White_effect_pattern_W2_256_new50.ppm');
    name='White_effect_pattern_W2_256_new50';
	 
elseif strcmp(M,'whi_new25')
    tmp=imread('White_effect_pattern_W2_256_new25.ppm');
    name='White_effect_pattern_W2_256_new25';    

elseif strcmp(M,'demo')
    tmp=imread('demo1.ppm');
    name='demo';
    
elseif strcmp(M,'nat1_256')
    tmp=imread('nat1_256.ppm');
    name='nat1_256'; 
    
elseif strcmp(M,'nat1_512')
    tmp=imread('nat1_512.ppm');
    name='nat1_512';    

elseif strcmp(M,'lena_256')
    tmp=imread('lena_256.ppm');
    name='lena_256'; 
    
elseif strcmp(M,'lena_512')
    tmp=imread('lena_512.ppm');
    name='lena_512';
    
elseif strcmp(M,'orientat_256')
    tmp=imread('orientat_256.ppm');
    name='orientat_256';     
    
elseif strcmp(M,'orientat_diag_256')
    tmp=imread('orientat_diag_256.ppm');
    name='orientat_diag_256';     
    
elseif strcmp(M,'orientat_ortog_256')
    tmp=imread('orientat_ortog_256.ppm');
    name='orientat_ortog_256'; 
    
    
elseif strcmp(M,'sinus_256_5')
    tmp=imread('sinus_256_5.ppm');
    name='sinus_256_5';   

elseif strcmp(M,'sinus_256_10')
    tmp=imread('sinus_256_10.ppm');
    name='sinus_256_10';
    
elseif strcmp(M,'sinus_256_15')
    tmp=imread('sinus_256_15.ppm');
    name='sinus_256_15';
elseif strcmp(M,'sinus_256_20')
    tmp=imread('sinus_256_20.ppm');
    name='sinus_256_20';
elseif strcmp(M,'sinus_256_25')
    tmp=imread('sinus_256_25.ppm');
    name='sinus_256_25';
elseif strcmp(M,'sinus_256_30')
    tmp=imread('sinus_256_30.ppm');
    name='sinus_256_30';
elseif strcmp(M,'sinus_256_35')
    tmp=imread('sinus_256_35.ppm');
    name='sinus_256_35';
elseif strcmp(M,'sinus_256_48')
    tmp=imread('sinus_256_48.ppm');
    name='sinus_256_48';
elseif strcmp(M,'sinus_256_68')
    tmp=imread('sinus_256_68.ppm');
    name='sinus_256_68';
elseif strcmp(M,'sinus_256_88')
    tmp=imread('sinus_256_88.ppm');
    name='sinus_256_88';
elseif strcmp(M,'sinus_256_108')
    tmp=imread('sinus_256_108.ppm');
    name='sinus_256_108';
elseif strcmp(M,'sinus_256_118')
    tmp=imread('sinus_256_118.ppm');
    name='sinus_256_118';
elseif strcmp(M,'sinus_256_98')
    tmp=imread('sinus_256_98.ppm');
    name='sinus_256_98';
elseif strcmp(M,'sinus_256_1')
    tmp=imread('sinus_256_1.ppm');
    name='sinus_256_1';
elseif strcmp(M,'sinus_256_2')
    tmp=imread('sinus_256_2.ppm');
    name='sinus_256_2';
elseif strcmp(M,'sinus_256_3')
    tmp=imread('sinus_256_3.ppm');
    name='sinus_256_3';
    % for [7,9,11,13,17,19,23,27,39,43,53,59,65,77,83,91,103,107,113,123];
elseif strcmp(M,'sinus_256_7')
    tmp=imread('sinus_256_7.ppm');
    name='sinus_256_7';
elseif strcmp(M,'sinus_256_9')
    tmp=imread('sinus_256_9.ppm');
    name='sinus_256_9';
elseif strcmp(M,'sinus_256_11')
    tmp=imread('sinus_256_11.ppm');
    name='sinus_256_11';
elseif strcmp(M,'sinus_256_13')
    tmp=imread('sinus_256_13.ppm');
    name='sinus_256_13';
elseif strcmp(M,'sinus_256_17')
    tmp=imread('sinus_256_17.ppm');
    name='sinus_256_17';
elseif strcmp(M,'sinus_256_19')
    tmp=imread('sinus_256_19.ppm');
    name='sinus_256_19';
elseif strcmp(M,'sinus_256_23')
    tmp=imread('sinus_256_23.ppm');
    name='sinus_256_23';
elseif strcmp(M,'sinus_256_27')
    tmp=imread('sinus_256_27.ppm');
    name='sinus_256_27';
elseif strcmp(M,'sinus_256_35')
    tmp=imread('sinus_256_35.ppm');
    name='sinus_256_35';    
elseif strcmp(M,'sinus_256_39')
    tmp=imread('sinus_256_39.ppm');
    name='sinus_256_39';
elseif strcmp(M,'sinus_256_43')
    tmp=imread('sinus_256_43.ppm');
    name='sinus_256_43';
elseif strcmp(M,'sinus_256_53')
    tmp=imread('sinus_256_53.ppm');
    name='sinus_256_53';
elseif strcmp(M,'sinus_256_59')
    tmp=imread('sinus_256_59.ppm');
    name='sinus_256_59';
elseif strcmp(M,'sinus_256_65')
    tmp=imread('sinus_256_65.ppm');
    name='sinus_256_65';
elseif strcmp(M,'sinus_256_77')
    tmp=imread('sinus_256_77.ppm');
    name='sinus_256_77';
elseif strcmp(M,'sinus_256_83')
    tmp=imread('sinus_256_83.ppm');
    name='sinus_256_83';
elseif strcmp(M,'sinus_256_91')
    tmp=imread('sinus_256_91.ppm');
    name='sinus_256_91';
elseif strcmp(M,'sinus_256_103')
    tmp=imread('sinus_256_103.ppm');
    name='sinus_256_103';
elseif strcmp(M,'sinus_256_105')
    tmp=imread('sinus_256_105.ppm');
    name='sinus_256_105';    
elseif strcmp(M,'sinus_256_107')
    tmp=imread('sinus_256_107.ppm');
    name='sinus_256_107';
elseif strcmp(M,'sinus_256_113')
    tmp=imread('sinus_256_113.ppm');
    name='sinus_256_113';
elseif strcmp(M,'sinus_256_123')
    tmp=imread('sinus_256_123.ppm');
    name='sinus_256_123';
    
    
    
elseif strcmp(M,'memorial')
    tmp=imread('memorial.ppm');
    name='memorial';
	 
elseif strcmp(M,'memorial_128')
    tmp=imread('memorial_128.ppm');
    name='memorial';

	 % Chromatic stimulus	 


elseif strcmp(M,'Assim_Verd_Blau_256')
    tmp=imread('Assimilacio_verd_blau_256.ppm');
    name='Assimilacio_verd_blau_256';
%    tmp = rgb2gray(tmp);
elseif strcmp(M,'Assim_Verd_Blau_256edited')
    tmp=imread('Assimilacio_verd_blau_256edited.ppm');
    name='Assimilacio_verd_blau_256edited';

elseif strcmp(M,'Contrast_Yellow_Green_128')
    tmp=imread('Contrast_Yellow_Green_128.ppm');
    name='Contrast_Yellow_Green_128';	 
elseif strcmp(M,'Contrast_Yellow_Green_256')
    tmp=imread('Contrast_Yellow_Green_256.ppm');
    name='Contrast_Yellow_Green_256';

elseif strcmp(M, 'Cercles_Assim_256')
    tmp=imread('cercles_assimilacio_256');
    name='cercles_assimilacio_256';
	 
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';    
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';
% elseif strcmp(n,'')
%     tmp=imread('');
%     name='';    
end

tmp2 = get_the_cstimulus(tmp,gamma,srgb_flag);


end


% tmp=imread('White_effect_pattern_W2_256.ppm'); % aquest
% str_name='White_effect_pattern_W2_256';
% tmp1=tmp;str_name1=str_name;

% tmp=imread('F10.large_retall.ppm'); % aquest
% str_name='F10_large_retall';
% tmp1=tmp;str_name1=str_name;

%tmp=imread('White_effect_pattern_W2.ppm');
%str_name='White_effect_pattern_W2';
%tmp=imread('SBC_effect_pattern_SBC1_256.ppm');
%tmp=imread('SBC_effect_pattern_SBC3_256.ppm');
%tmp=imread('Todorovic_effect_pattern_T.ppm');
%str_name='Tod';

% tmp=imread('Todorovic_effect_pattern_T_256.ppm');
% str_name='Tod_256';
% tmp2=tmp;str_name2=str_name;
% tmp=imread('F12.large_retall.ppm');
% str_name='F12_large_retall';
% tmp2=tmp;str_name2=str_name;

%tmp=imread('Todorovic_effect_pattern_T_512.ppm');
%str_name='Tod_512';
% tmp=imread('Chevreul_pattern.ppm');
% str_name='Chevreul_pattern';
% tmp3=tmp;str_name3=str_name;

% tmp3=tmp;str_name3=str_name;
% 
% tmp1=(double(tmp1)-128)*0.5+128;
% tmp2=(double(tmp2)-128)*0.5+128;
% tmp3=(double(tmp3)-128)*0.5+128;
