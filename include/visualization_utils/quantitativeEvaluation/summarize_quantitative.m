function [ ] = summarize_quantitative( models_list,evaluation, evaluation_idx, paths)

    supercell={'evaluation_value','saliency_index','condition','filename','model'};
    
    for model=1:numel(models_list)
        model_csv_path=paths.results_quantitative_csv_paths{evaluation_idx}{model};
       if exist( model_csv_path,'file' )
           results_cell_model=r_csv(model_csv_path); 
           results_cell_model(2:end,5)={models_list{model}};
           supercell=[supercell; results_cell_model(2:end,1:5)];
       end
       
    end
    
    %conditions=unique(results_cell(2:end,3));
    %models=unique(results_cell(2:end,5));
    %evaluations=unique(cell2mat(results_cell(2:end,1)));
    
    if size(supercell,1)>1 
       conditions=unique(supercell(2:end,3));
       for condition=1:numel(conditions)
           w_csv(supercell,[paths.output_path '/' evaluation '.csv']); 
           runResults_permodel(supercell,{conditions{condition}});
           title([evaluation '/' conditions{condition}])
           saveas(gcf, [paths.output_path '/'  evaluation '_' conditions{condition}], 'png');
           close all;
       end
    end
    
    if size(supercell,1)>1
       runResults_mean(supercell); 
       title(evaluation);
       saveas(gcf, [paths.output_path '/'  evaluation], 'png');
       close all;
    end
    

end

