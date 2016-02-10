

%recursive addpath
raddpath('include');
raddpath('input');


%read images /improcdir
    %imap = imread('i05june05_static_street_boston_p1010764.jpeg');
smap = imread('si05june05_static_street_boston_p1010764.jpeg');
fmap = imread('i05june05_static_street_boston_p1010764_fixMap.jpg');
fmap_other = imread('i05june05_static_street_boston_p1010800_fixMap.jpg');
fmap_other2 = fmap_other+fmap;



%compute metrics

[ score_roc,  score_roc_curve] = get_roc( smap, fmap, fmap_other);

score_KLD = get_kl( smap, fmap, fmap_other);

 %score_AUC_Judd = AUC_Judd(smap, fmap, 1, 0); %tarda molt

 score_AUC_Shuffled = AUC_shuffled(smap, fmap, fmap_other , 100, 0.1 , 0);

 score_AUC_Borji = AUC_Borji(smap, fmap, 100, 0.1, 0);

 score_CC = CC(smap, fmap);

 score_EMD = EMD(smap, fmap, 0);

 score_NSS = NSS(smap, fmap);

 score_Similarity = similarity(smap, fmap, 0);











