% adaptation of find_parameters_general_NCZLd_v2.m
% for SINUSOIDAL GRATINGS ONLY
% toward a good set of parameters (created 14/9/12)
% based on [img,img_out]=general_NCZLd(image_name,mida_min,epsilon,kappay,normal_output) 

% 1. images we want to analyze
%names={'SBC1_256'};
%names={'todo_256'};
% names={'whi_128'};  % debug only
% names={'mach_128','che_128','whi_128','todo_128','grating_128'};
%names={'mach_256','che_256','whi_256','todo_256','grating_256'};
%names={'mach_256','che_256','whi_256','todo_256','grating_256','SBC1_256'};
% two in parallel
%names={'mach_256','che_256','whi_256'};
%names={'todo_256','grating_256','SBC1_256'};
%names={'sinus_256_5','sinus_256_10','sinus_256_15','sinus_256_20','sinus_256_25','sinus_256_30'};
%names={'sinus_256_35','sinus_256_48','sinus_256_68','sinus_256_88','sinus_256_108','sinus_256_128'};
%names={'sinus_256_1','sinus_256_2','sinus_256_3'};
%names={'sinus_256_98','sinus_256_118'};
% for [7,9,11,13,17,19,23,27,39,43,53,59,65,77,83,91,103,107,113,123];
names={'sinus_256_7','sinus_256_9','sinus_256_11','sinus_256_13','sinus_256_17'};
%names={'sinus_256_19','sinus_256_23','sinus_256_27','sinus_256_39','sinus_256_43'};
%names={'sinus_256_53','sinus_256_59''sinus_256_65','sinus_256_77','sinus_256_83'};
%names={'sinus_256_91','sinus_256_103','sinus_256_107''sinus_256_113','sinus_256_123'};
% 2. values for mida_min
mida_min=[32];  % was [32,16]

% 3. values for epsilon
epsilon=[1.1];

% 4. values for kappay
kappay=[1.5];

% 5. values for normal_output
% normal_output=[1.75];   % [1.5:0.25:1.75]
normal_output=[1.75];

% loop over the parameters
for i2=1:1
    for i3=1:1
        for i4=1:1
            for i5=1:1
                for i1=1:12
                    [img,img_out]=general_NCZLd(names{i1},mida_min(i2),epsilon(i3),kappay(i4),normal_output(i5));
                    %i2,i3,i4,i5
                end
            end
        end
    end
end

