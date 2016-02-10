function z=is_symmetric(M,eps)

% check the symmetry (up to eps) of the input with respect
% to the first dimension

%mm=size(M,1);
diff=abs(M-fliplr(M));

z=1;
if max(max(diff))>eps
    z=0;
end
end