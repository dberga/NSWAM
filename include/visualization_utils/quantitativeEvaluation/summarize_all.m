function [ ] = summarize_all( models_list,evaluation_list, paths)
    
    supercell={'evaluation_value','saliency_index','condition','filename','model','evaluation'};
    
    for evaluation_idx=1:numel(evaluation_list)
        for model=1:numel(models_list)
            model_csv_path=paths.results_quantitative_csv_paths{evaluation_idx}{model};
           if exist( model_csv_path,'file' )
               results_cell_model=r_csv(model_csv_path); 
               results_cell_model(2:end,5)={models_list{model}};
               results_cell_model(1:end,6)=cellstr(evaluation_list{evaluation_idx});
               supercell=[supercell; results_cell_model(2:end,1:6)];
           end
        end
    end
    
    %conditions=unique(results_cell(2:end,3));
    %models=unique(results_cell(2:end,5));
    %evaluations=unique(cell2mat(results_cell(2:end,1)));
    
    if size(supercell,1)>1
       barResults_mean(supercell); 
       saveas(gcf, [paths.output_path '/' 'eval_all'], 'png');
       close all;
    end
    
    if size(supercell,1)>1
       barResults_all(supercell); 
       saveas(gcf, [paths.output_path '/' 'all'], 'png');
       close all;
    end
end



