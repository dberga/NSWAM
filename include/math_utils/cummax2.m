function m = cummax2(x)
    [X, ~] = meshgrid(x, ones(size(x)));
    %replace elements above diagonal with -inf
    X(logical(triu(ones(size(X)),1))) = -inf;
    %get cumulative maximum
    m = reshape(max(X'), size(x));
end