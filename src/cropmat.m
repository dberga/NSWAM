function [ croppedmatrix , matrix_bg] = cropmat( matrix, xmin, xmax, ymin, ymax )
    matrix_bg=matrix;
    for t=1:length(matrix) %1d
        for iter=1:length(matrix{t}) %2d
            for s=1:length(matrix{t}{iter}) %3d
                for o=1:length(matrix{t}{iter}{s}) %4d
                    xlims=floor([xmin*size(matrix{t}{iter}{s}{o},2),xmax*size(matrix{t}{iter}{s}{o},2)])+1;
                    ylims=floor([ymin*size(matrix{t}{iter}{s}{o},1),ymax*size(matrix{t}{iter}{s}{o},1)])+1;
                    croppedmatrix{t}{iter}{s}{o}=matrix{t}{iter}{s}{o}(ylims(1):ylims(2),xlims(1):xlims(2));
                    matrix_bg{t}{iter}{s}{o}(ylims(1):ylims(2),xlims(1):xlims(2))=NaN;
                end
            end
        end
    end
        
end

