result_s = [];
for scale_f = (1:7) - 2
    [meanroc seroc meanKL seKL mean_curve] = eval_shffle_roc_comparisonv7('parallel', 'testing_ch_v0', 100, 13, 23,scale_f, []);
    result_s = [result_s; meanroc seroc meanKL seKL]
end
result_s