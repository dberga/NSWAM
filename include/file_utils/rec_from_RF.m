

function [rec] = rec_from_RF(image_name, variable, folder)


channels = ['chromatic' 'chromatic2' 'intensity'];

 mpath_c1 = [folder image_name '_' variable '_channel(' channels(1) ')' '.mat'];
 mpath_c2 = [folder image_name '_' variable '_channel(' channels(2) ')' '.mat'];
 mpath_c3 = [folder image_name '_' variable '_channel(' channels(3) ')' '.mat'];
 
 
 rec(:,:,1) = RF_to_rec_channel(mpath_c1);
 rec(:,:,2) = RF_to_rec_channel(mpath_c2);
 rec(:,:,3) = RF_to_rec_channel(mpath_c3);
 
 
 
end

 