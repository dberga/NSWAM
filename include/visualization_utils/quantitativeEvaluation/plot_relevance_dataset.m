function [  ] = plot_relevance_dataset( image_folder, mask_folder, relevance_folder, fig_output_folder ,results_csv_path)
if nargin<1,    image_folder='Original Image Set';end
if nargin<2,    mask_folder='gt_sod_mascaras';end
if nargin<4, relevance_folder='.';end
if nargin<5,  fig_output_folder='output_relevance'; mkdir(fig_output_folder); end
if nargin<6, results_csv_path='.'; end %results_csv_path='tsotsos'; end 
selected_models={'dmaps','no_cortical_config_b1_15_sqmean_fusion2_invdefault','topdown_single_config_b1_15_fusion2'};

for i=1:120
   plot_relevance([image_folder '/' num2str(i) '.jpg'], [mask_folder '/' num2str(i) '.png'],selected_models,results_csv_path)
   savefig([fig_output_folder '/' num2str(i) '.fig']);
   fig2png([fig_output_folder '/' num2str(i) '.fig'],[fig_output_folder '/' num2str(i) '.png']);
   close all;
end

end

