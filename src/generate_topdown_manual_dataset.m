function [  ] = generate_topdown_manual_dataset( input_dataset_folder )
if nargin < 1, input_dataset_folder='input_sid4vam'; end
conf_name='swam_max_topdown_single_config_b1_15_fusion2';

files=listpath(input_dataset_folder);
for f=1:length(files)
   disp(['Computing ...' files{f}]);
   [imfolder,imname,imext]=fileparts([input_dataset_folder '/' files{f}]);
   img=im2double( imread([input_dataset_folder '/' files{f}]));
   image_props.input_folder=input_dataset_folder;
   image_props.image_name_noext=imname;
   figure,imagesc(img);
   conf_struct=generate_topdown(img,image_props,conf_name);
   close all;
end

end

%fv1: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=1; matrix_in.polarity=2;
%fv2: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=[1,2,3]; matrix_in.polarity=2;
%fv3: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=3; matrix_in.polarity=2;
%fv4: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=2; matrix_in.polarity=2;
%fv5: matrix_in.channels=3; matrix_in.scales=1:6; matrix_in.orientations=3; matrix_in.polarity=2;

%vs1: matrix_in.channels=1; matrix_in.scales=1:3; matrix_in.orientations=3; matrix_in.polarity=1;
%vs2: 
    %c-cb: matrix_in.channels=3; matrix_in.scales=1:6; matrix_in.orientations=[1:2]; matrix_in.polarity=2;
    %cb-c: matrix_in.channels=3; matrix_in.scales=1:6; matrix_in.orientations=[3]; matrix_in.polarity=2;
%vs3: matrix_in.channels=3; matrix_in.scales=1:2; matrix_in.orientations=1:3; matrix_in.polarity=1;
%vs4: 
    %red: matrix_in.channels=1; matrix_in.scales=1:3; matrix_in.orientations=1:3; matrix_in.polarity=1;
    %blue: matrix_in.channels=2; matrix_in.scales=1:3; matrix_in.orientations=1:3; matrix_in.polarity=2;
%vs5: 
    %hB: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=1:3; matrix_in.polarity=2;
    %bB: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=1:3; matrix_in.polarity=1;
%vs6: matrix_in.channels=3; matrix_in.scales=3:6; matrix_in.orientations=3; matrix_in.polarity=2;
%vs7: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=3; matrix_in.polarity=2;
%vs8: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=[1,2,3]; matrix_in.polarity=2;
%vs9: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=[1,2,3]; matrix_in.polarity=2;
%vs10: matrix_in.channels=3; matrix_in.scales=1:3; matrix_in.orientations=[1,2,3]; matrix_in.polarity=2;