function r = AngularError(l1, l2)
% AngularError  calculates the angular error between two vectors
%
% inputs
%   l1  vector one, assumed to be normalised.
%   l2  vector one, assumed to be normalised.
%
% outputs
%   r  the angular error between the two vectors.
%

l1 = l1 / sqrt(sum(l1 .^ 2));
l2 = l2 / sqrt(sum(l2 .^ 2));
r = acosd(sum(l1(:) .* l2(:)));

end
