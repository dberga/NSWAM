function nn = inmod(n,l1,l2)

    n(~isfinite(n))=1; 
    nn = n;
    
    modif1 = abs(n) > l2;
    modif2 = n < l1;
    
    odd = mod(ceil(n/l2),2); odd = logical(odd);
    modif4 = modif1 & odd | modif2 & ~odd;
    modif5 = modif1 & ~odd | modif2 & odd;
    
    %negatives go reversed
    nn(modif2) = abs(nn(modif2));
    
    %transform plane coordinates outside the map
    nn(modif1)=mod(nn(modif1),l2); 
    
    %for odd planes outside, do not apply fliping
    nn(modif4)=nn(modif4);
    
    %for even planes outside, apply fliping
    nn(modif5) = l2-(nn(modif5));
    
    nn(find(nn==0))=1;
    
    
end