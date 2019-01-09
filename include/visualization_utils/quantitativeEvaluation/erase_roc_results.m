function [  ] = erase_roc_results( folder )

dirs=listpath_dir(folder);
for i=1:length(dirs)
    results_struct_folder=[folder '/' dirs{i} '/' 'results.mat'];
    load(results_struct_folder);
    for m=1:length(results_struct.metrics)
        if isfield(results_struct.metrics{m},'roc_all')
            results_struct.metrics{m}=rmfield(results_struct.metrics{m},'roc_all');
        end
    end
    for m=1:length(results_struct.metrics_gazewise)
        if isfield(results_struct.metrics_gazewise{m},'roc_all')
            results_struct.metrics_gazewise{m}=rmfield(results_struct.metrics_gazewise{m},'roc_all');
        end
    end
    save(results_struct_folder,'results_struct');
end

end

