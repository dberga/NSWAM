function [ ] = runResults_percondition( results_cell )
    
    figure('Position', [100, 100, 1024, 768]);
    
    conditions=unique(results_cell(2:end,3));
    evaluations=unique(cell2mat(results_cell(2:end,1)));
%     colormap = rand(numel(conditions),3);
    for condition=1:numel(conditions)
        condition_rows=find(strcmp(results_cell(2:end,3),conditions{condition}))+1;
        %x_results=cell2mat(results_cell(2:end,1)');
        %y_results=cell2mat(results_cell(2:end,2)');
        %x_results=cell2mat(results_cell(numel(evaluations)*(condition-1)+2:numel(evaluations)*(condition)+1,1)');
        %y_results=cell2mat(results_cell(numel(evaluations)*(condition-1)+2:numel(evaluations)*(condition)+1,2)');
        x_results=cell2mat(results_cell(condition_rows,1)');
        y_results=cell2mat(results_cell(condition_rows,2)');
        hold on;
%         plot(x_results,y_results,'-x','color',colormap(condition,:),'LineWidth',1.5);
plot(x_results,y_results,'-x','LineWidth',1.5);
        
        %ylim([min(cell2mat(results_cell(2:end,2)')) max(cell2mat(results_cell(2:end,2)'))]);
    end
    legend(conditions);
    ylabel( sprintf(results_cell{1,2}) , 'FontSize', 11);
    xlabel( sprintf(results_cell{1,1}) , 'FontSize', 11);
    
    %title(sprintf(['Nonlinearity of saliency perception with respect to ' results_cell{1,1}]), 'FontSize', 12);

    paperPosition=[0 0 7.2 6];
    set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
    %print(gcf,'-depsc2', sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir ,flag_exp, algrt.nome{indexAltg},fr));
    %saveas(gcf, sprintf('%s/exp%d_%s_fr%.1f.jpg', fig_dir , flag_exp, algrt.nome{indexAltg},fr), 'jpg');
    colormap default;

end
