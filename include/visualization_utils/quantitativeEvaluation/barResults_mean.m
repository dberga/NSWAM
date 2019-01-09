function [  ] = barResults_mean( results_cell )

    figure('Position', [100, 100, 4096, 3072]);
    models=unique(results_cell(2:end,5));
    evaluations=unique(results_cell(2:end,6));
%     colormap = rand(numel(models),3);

    
    yallall=[];
        for evaluation=1:numel(evaluations)
            evaluation_rows=find(strcmp(results_cell(2:end,6),evaluations{evaluation}))+1;
            yall=[];
            for model=1:numel(models)
                model_rows=find(strcmp(results_cell(2:end,5),models{model}))+1;
                model_evaluation_rows=intersect(model_rows,evaluation_rows);
                yall=[yall; cell2mat(results_cell(model_evaluation_rows,2)')];
            end
            yallall=[yallall; mean(yall')];
        end
    y_results=yallall;
    bar(y_results,'hist');
    set(gca,'XTick',1:numel(evaluations))
    set(gca,'XtickLabel',evaluations);
    set(gca,'XtickLabel',evaluations);
    
    colormap default;
    legend(models);
        
    ylabel( sprintf(results_cell{1,2}) , 'FontSize', 11);
    
end

