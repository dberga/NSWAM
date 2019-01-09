function [ ] = runResults_mean( results_cell, conditions )
    if nargin < 2, conditions=unique(results_cell(2:end,3)); end
    
    figure('Position', [100, 100, 1024, 768]);
    models=unique(results_cell(2:end,5));
    evaluations=unique(cell2mat(results_cell(2:end,1)));
%     colormap = rand(numel(models),3);
    
    for model=1:numel(models)
%         model_rows=find(~cellfun(@isempty,strfind(results_cell(2:end,5),models{model})))+1;
        model_rows=find(strcmp(results_cell(2:end,5),models{model}))+1;
        yall=[];
        for condition=1:numel(conditions)
%             condition_rows=find(~cellfun(@isempty,strfind(results_cell(2:end,3),conditions{condition})))+1;
            condition_rows=find(strcmp(results_cell(2:end,3),conditions{condition}))+1;
            model_condition_rows=intersect(model_rows,condition_rows);
            yall=[yall; cell2mat(results_cell(model_condition_rows,2)')];

            
        end
        x_results=evaluations;
        y_results=mean(yall); if numel(conditions)<2, y_results=yall; end
        hold on;
        %plot(x_results,y_results,'-x','color',colormap(model,:),'LineWidth',1.5);
        plot(x_results,y_results,'-x','LineWidth',1.5);
        %ylim([min(cell2mat(results_cell(2:end,2)')) max(cell2mat(results_cell(2:end,2)'))]);
    end
    legend(models);
    ylabel( sprintf(results_cell{1,2}) , 'FontSize', 11);
    xlabel( sprintf(results_cell{1,1}) , 'FontSize', 11);
    
    %title(sprintf(['Nonlinearity of saliency perception with respect to ' results_cell{1,1}]), 'FontSize', 12);

    paperPosition=[0 0 7.2 6];
    set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
    %print(gcf,'-depsc2', sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir ,flag_exp, algrt.nome{indexAltg},fr));
    %saveas(gcf, sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir , flag_exp, algrt.nome{indexAltg},fr), 'jpg');

    colormap default;
end
