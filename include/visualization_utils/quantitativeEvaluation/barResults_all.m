function [  ] = barResults_all( results_cell )

    figure('Position', [100, 100, 1024, 768]);
    models=unique(results_cell(2:end,5));
    evaluations=unique(results_cell(2:end,6));
%     colormap = rand(numel(models),3);

    
    yall=[];
    for model=1:numel(models)
        model_rows=find(strcmp(results_cell(2:end,5),models{model}))+1;
        yall=[yall; mean(cell2mat(results_cell(model_rows,2)'))];
%         for evaluation=1:numel(evaluations)
%             evaluation_rows=find(strcmp(results_cell(2:end,6),evaluations{evaluation}))+1;
%             model_evaluation_rows=intersect(model_rows,evaluation_rows);
%             yall=[yall; cell2mat(results_cell(model_evaluation_rows,2)')];
%         end
        
        
    end
    %x_results=1:numel(models);
    y_results=yall;
    %hold on;
    bar(y_results);
    set(gca,'XTick',1:numel(models))
    set(gca,'XtickLabel',models);
    
    colormap default;
    
%     ylabel( sprintf(results_cell{1,2}) , 'FontSize', 11);

end

