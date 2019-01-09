function [ multidim_on,multidim_off ] = multidim2onoff( multidim )
    multidim_on=multidim;
    multidim_off=-multidim;
    multidim_on(find(multidim<=0))=0;
    multidim_off(find(multidim>=0))=0;
end

