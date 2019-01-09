function [ opp ] = normalize_channels( opp, min, max )
    if nargin < 2, min=0; end %-1
    if nargin < 3, max=1; end %1
    %minimums and maximums
    Lminmax=[0,3];
    aminmax=[-1,1];
    bminmax=[-2,1];
    
    %normalize to 0 and 1 for each corresponding channel
    opp(:,:,1)=normalize_minmax(opp(:,:,1),aminmax(1),aminmax(2));
    opp(:,:,2)=normalize_minmax(opp(:,:,2),bminmax(1),bminmax(2));
    opp(:,:,3)=normalize_minmax(opp(:,:,3),Lminmax(1),Lminmax(2));
    
    %normalize to specific values
    opp=normalize_spec(opp,min,max);
    
end

