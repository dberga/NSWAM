function [curv,n_scales]=Gabor_decomposition(img)

tic
% parameters from the thorough study by Serre et al. 
rot=[0 45 90 135]; % gives the number of orientations (default: rot=[0 45 90 135])
RF_siz=(7:2:39);   % scales we consider (default: RF_siz=(7:2:39)) 
Div=5;

% get the Gabor filters (from Serre et al.)
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);

% choose the resolution
c1SpaceSS=(8:2:22);
c1ScaleSS=(1:2:17);
INCLUDEBORDERS=0;

% loop over all the images 
nx=size(img,1);
ny=size(img,2);
nz=size(img,3);
nt=size(img,4);  % iteration number
nnbfilters=size(filters,2);
nrot=size(rot,2);
curv=cell(nt,((nnbfilters/nrot)-1)/2,nrot); % we want to preserve the format we use for wavelets
stim=img;

for tt=1:nt
    % get the response of the filters
    [c1,s1] = C1(stim(:,:,:,tt), filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,INCLUDEBORDERS);
    % put the response in the right format
    for sc=1:((nnbfilters/nrot)-1)/2 % cfr. convention in Serre C1.m (last element in c1ScaleSS is max index + 1 )
        for o=1:nrot
                mm(o)=max(max(s1{sc}{1}{o}));
        end
        mmm=max(mm(1:4));
		  mmm=1.;
        for o=1:nrot % 2 is the number of phases
            % tt
            % sc
            % o
             curv{tt}{sc}{o}=s1{sc}{1}{o}./mmm;%./max(max(s1{sc}{1}{o})); % FIRST NORMALIZATION OP 
             % until 30 4 2012
        end     
        % curv{tt}{sc+4}=s1{sc}{2}; % we only consider one phase
    end    
end    

toc

n_scales=((nnbfilters/nrot)-1)/2 ;
end