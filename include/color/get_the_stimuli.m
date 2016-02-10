function [tmp1,name1,tmp2,name2,tmp3,name3]=get_the_stimuli(M,gamma,srgb_flag)

[tmp1,name1]=get_the_stimulus(M(1),gamma,srgb_flag);
[tmp2,name2]=get_the_stimulus(M(2),gamma,srgb_flag);
[tmp3,name3]=get_the_stimulus(M(3),gamma,srgb_flag);

end
