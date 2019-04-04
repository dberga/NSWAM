img_path=['input/111.png'];
dataset_out_path='/home/dberga/repos/metrics_saliency/input/smaps/tsotsos_original_reserva';
GT_path='/home/dberga/repos/metrics_saliency/input/scanpaths/tsotsos';
gazesnum=10;
ior_peak=1;


pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=[1 0.999 0.99 .95 0.9 0.75 0.5 0.25 0];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,6*(511./pxva));
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*4);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*2);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*1);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=[1 0.999 0.99 .95 0.9 0.75 0.5 0.25 0];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,6*(511./pxva));
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*4);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*2);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*1);


pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=[1 0.999 0.99 .95 0.9 0.75 0.5 0.25 0];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,6*(511./pxva));
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*4);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*2);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*1);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=[1 0.999 0.99 .95 0.9 0.75 0.5 0.25 0];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,6*(511./pxva));
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*4);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*2);
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,pxva*1);

pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=1;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=1;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=1;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=1;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.999;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.999;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.999;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.999;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);


pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.99;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.99;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.99;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.99;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);


pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.95;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.95;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.95;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.95;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);



pxva=40;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.9;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.9;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

pxva=32;
model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
ior_decay=.9;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault';
ior_decay=.9;
ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
test_ior_static(img_path,model_name,dataset_out_path,GT_path,gazesnum,ior_decay,ior_peak,ior_std_angle);

