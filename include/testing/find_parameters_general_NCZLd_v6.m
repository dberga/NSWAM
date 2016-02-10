% from v2; use parameters similar to the one v2 used; add SBC3_256
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
names={'mach_256','che_256','whi_256'};
%names={'todo_256','grating_256'};
%names={'SBC1_256','SBC3_256'};
% 2. values for mida_min
mida_min=[32];  % was [32,16]

% 3. values for epsilon
epsilon=[1.1:0.1:1.3];

% 4. values for kappay
kappay=[1.25:0.25:2];

% 5. values for normal_output
% normal_output=[1.75];   % [1.5:0.25:1.75]
normal_output=[1.5:0.25:1.75];

% loop over the parameters
for i2=1:size(mida_min,2)
    for i3=1:size(epsilon,2)
        for i4=1:size(kappay,2)
            for i5=1:size(normal_output,2)
                for i1=1:size(names,2)
                    [img,img_out]=general_NCZLd(names{i1},mida_min(i2),epsilon(i3),kappay(i4),normal_output(i5));
                    %i2,i3,i4,i5
                end
            end
        end
    end
end

