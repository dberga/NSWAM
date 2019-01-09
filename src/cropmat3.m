function [ croppedmatrix , matrix_bg] = cropmat( matrix, xmin, xmax, ymin, ymax )
    matrix_bg=matrix;
    for s=1:length(matrix) %3d
            xlims=round([xmin*size(matrix{s},2),xmax*size(matrix{s},2)]);
            ylims=round([ymin*size(matrix{s},1),ymax*size(matrix{s},1)]);
            if xlims(1) < 1, xlims(1)=1; end
            if xlims(2) > size(matrix{s},2), xlims(2)=size(matrix{s},2); end
            if ylims(1) < 1, ylims(1)=1; end
            if ylims(2) > size(matrix{s},1), ylims(2)=size(matrix{s},1); end

            croppedmatrix{s}=matrix{s}(ylims(1):ylims(2),xlims(1):xlims(2));
            matrix_bg{s}(ylims(1):ylims(2),xlims(1):xlims(2))=NaN;
    end
end

