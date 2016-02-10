function outpic = generate_colinduct_stim(experiment,inductor,inductor_far,testcol,testcol2, num_stripes,grey, bckgr)
% Generation of colour induction stimuli.
% This might not be the most efficient way of generating colour induction
% stimuli, but it follows the steps of the program I created to do so for
% my colour induction experiments in 2007.
% 
% PARAMETERS:
%   experiment: type of experiment. There are only three (shevell, contrast
%               and assimilation).
%   inductor: colour value of immediate inductor ring (or bar)
%   inductor_far: colour value of far inductor ring (or bar)
%   testcol: colour of the stim inductor ring (or bar)
%   testcol2: colour of the test inductor ring (or bar)
%   num_stripes: number of rings (or stripes). It can be either 5, 7 or 11;
%               It defaults to 5
%   grey: the colour coordinates of grey. It can be omitted of set to the
%               right values below.

% Example: 

% test = generate_colinduct_stim('assimilation',[100 0 110],[180 0 20],[200 200 0],11);

% NEEDS:
%   RawShevellCircles.m
%   getmepos.m
%   RawAssimilationImage.m

if nargin < 6
% IMPORTANT always set the value of "grey" to correspond to the greylevel 
% used in the COLOUR SPACE that is relevant!!!
    grey = [128 128 128]; 
end
if nargin < 5
    num_stripes = 7;
end

% The test colour is the same in both (left and rigth) patches. This is not
% strictly true, as the right patch was "jiggled" (slightly randomised)
% from its starting position. However these jiggled values were different
% for each trial/observer and were not recorded. The randomisation was
% always less than 0.05 (5%).
% testcol2 = testcol;

% This is the size in pixels of the coloured stimuli that were presented on
% both sides of the screen
%size=512;
size=512/2;

% Thicknes of test ring relative to thicknes of inductor rings.
% Equal width for all rings is test_thickness=1
test_thickness = 1.;

% Dimensions in pixels of the monitor screen
%ScreenWidth = 1280;
%ScreenHeight = 1024;
ScreenWidth = 1280/2;
ScreenHeight = 1024/2;

% The parameters below are set to correspond to the actual parameters used
% in the experiment. Modify ONLY if you know what you're doing.
Bitmap = ones(ScreenHeight,ScreenWidth);
scrpos1 = 'left';
scrpos2 = 'right';
Ttestcol = 4;
Tinductor = 5;
Tinductor_far = 6;
Ttestcol2 = 14;
Tinductor2 = 15;
Tinductor_far2 = 16;

%Generate the bitmap (one plane)
experiment = lower(experiment);
switch experiment
    case 'shevell'
        BitsPic1 = RawShevellCircles(size,Tinductor,Tinductor_far,Ttestcol,test_thickness,num_stripes);
        BitsPic2 = RawShevellCircles(size,Tinductor2,Tinductor_far2,Ttestcol2,test_thickness,num_stripes);
        [rectSource1 rectDest1] = getmepos(ScreenWidth, ScreenHeight, BitsPic1, scrpos1);
        [rectSource2 rectDest2] = getmepos(ScreenWidth, ScreenHeight, BitsPic2, scrpos2);
        Bitmap(rectDest1(2):rectDest1(4)-1,rectDest1(1):rectDest1(3)-1) = BitsPic1;
        Bitmap(rectDest2(2):rectDest2(4)-1,rectDest2(1):rectDest2(3)-1) = BitsPic2;        
        inductor2 = grey;
        inductor_far2 = grey;
    case 'contrast'
        BitsPic1 = RawShevellCircles(size,Tinductor,Tinductor,Ttestcol,test_thickness,num_stripes);
        BitsPic2 = RawShevellCircles(size,Tinductor2,Tinductor2,Ttestcol2,test_thickness,num_stripes);
        [rectSource1 rectDest1] = getmepos(ScreenWidth, ScreenHeight, BitsPic1, scrpos1);
        [rectSource2 rectDest2] = getmepos(ScreenWidth, ScreenHeight, BitsPic2, scrpos2);
        Bitmap(rectDest1(2):rectDest1(4)-1,rectDest1(1):rectDest1(3)-1) = BitsPic1;
        Bitmap(rectDest2(2):rectDest2(4)-1,rectDest2(1):rectDest2(3)-1) = BitsPic2;  
        inductor2 = grey;
        inductor_far2 = grey;
    case 'assimilation'
        test_height = .5;
        stripe_width_pix = round(size./num_stripes);
        test_stripe_pos = round(num_stripes/2 -1);
        BitsPic1 = RawAssimilationImage(size, num_stripes, stripe_width_pix, test_stripe_pos, test_height, test_thickness, Tinductor, Tinductor_far, Ttestcol);
        BitsPic2 = RawAssimilationImage(size, num_stripes, stripe_width_pix, test_stripe_pos, test_height, test_thickness, Tinductor2, Tinductor_far2, Ttestcol2);
        [rectSource1 rectDest1] = getmepos(ScreenWidth, ScreenHeight, BitsPic1, scrpos1);
        [rectSource2 rectDest2] = getmepos(ScreenWidth, ScreenHeight, BitsPic2, scrpos2);
        Bitmap = ones(ScreenHeight,ScreenWidth); 
        Bitmap(rectDest1(2):rectDest1(4)-1,rectDest1(1):rectDest1(3)-1) = BitsPic1;
        Bitmap(rectDest2(2):rectDest2(4)-1,rectDest2(1):rectDest2(3)-1) = BitsPic2; 
        inductor2 = inductor_far; %the stripes are exchanged!
        inductor_far2 = inductor;
    otherwise
        disp('Something went wrong...');
        disp('Usage: outpic = generate_colinduct_stim(experiment,inductor,inductor_far,testcol,num_stripes,grey)');
end

outpic = zeros(ScreenHeight,ScreenWidth,3);
outpic(:,:,1)=bckgr(1);
outpic(:,:,2)=bckgr(2);
outpic(:,:,3)=bckgr(3);

% outpic(:,:,1) = outpic(:,:,1) + inductor(1).*(Bitmap==Tinductor)...
%     + inductor_far(1).*(Bitmap==Tinductor_far)...
%     + testcol(1).*(Bitmap==Ttestcol) + testcol2(1).*(Bitmap==Ttestcol2)...
%     + inductor2(1).*(Bitmap==Tinductor2) + inductor_far2(1).*(Bitmap==Tinductor_far2);
% 
% outpic(:,:,2) = outpic(:,:,2) + inductor(2).*(Bitmap==Tinductor)...
%     + inductor_far(2).*(Bitmap==Tinductor_far)...
%     + testcol(2).*(Bitmap==Ttestcol) + testcol2(2).*(Bitmap==Ttestcol2)...
%     + inductor2(2).*(Bitmap==Tinductor2) + inductor_far2(2).*(Bitmap==Tinductor_far2);
% 
% outpic(:,:,3) = outpic(:,:,3) + inductor(3).*(Bitmap==Tinductor)...
%     + inductor_far(3).*(Bitmap==Tinductor_far)...
%     + testcol(3).*(Bitmap==Ttestcol) + testcol2(3).*(Bitmap==Ttestcol2)...
%     + inductor2(3).*(Bitmap==Tinductor2) + inductor_far2(3).*(Bitmap==Tinductor_far2);

 outpic(:,:,1) = outpic(:,:,1) + (inductor(1)-bckgr(1)).*(Bitmap==Tinductor)...
     + (inductor_far(1)-bckgr(1)).*(Bitmap==Tinductor_far)...
     + (testcol(1)-bckgr(1)).*(Bitmap==Ttestcol) + (testcol2(1)-bckgr(1)).*(Bitmap==Ttestcol2)...
     + (inductor2(1)-bckgr(1)).*(Bitmap==Tinductor2) + (inductor_far2(1)-bckgr(1)).*(Bitmap==Tinductor_far2);
 
 outpic(:,:,2) = outpic(:,:,2) + (inductor(2)-bckgr(2)).*(Bitmap==Tinductor)...
     + (inductor_far(2)-bckgr(2)).*(Bitmap==Tinductor_far)...
     + (testcol(2)-bckgr(2)).*(Bitmap==Ttestcol) + (testcol2(2)-bckgr(2)).*(Bitmap==Ttestcol2)...
     + (inductor2(2)-bckgr(2)).*(Bitmap==Tinductor2) + (inductor_far2(2)-bckgr(2)).*(Bitmap==Tinductor_far2);
 
 outpic(:,:,3) = outpic(:,:,3) + (inductor(3)-bckgr(3)).*(Bitmap==Tinductor)...
     + (inductor_far(3)-bckgr(3)).*(Bitmap==Tinductor_far)...
     + (testcol(3)-bckgr(3)).*(Bitmap==Ttestcol) + (testcol2(3)-bckgr(3)).*(Bitmap==Ttestcol2)...
     + (inductor2(3)-bckgr(3)).*(Bitmap==Tinductor2) + (inductor_far2(3)-bckgr(3)).*(Bitmap==Tinductor_far2);
