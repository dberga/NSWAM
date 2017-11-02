function [distmap] = bmap2distmap(bmap)

distmap = normalize_minmax(imcomplement(bwdist(bmap)));

end

