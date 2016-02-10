
function [input_image_resized] = autoresize_nd(input_image,strct,nd_ctt)
     %nd_ctt = La constant (numero de neurones de matcon.) es specific size/Delta
        %exemple: ctt = 512/15 = 34
        %if s=256x256,Delta=15,ctt=34 -> snew = 256*0.5 = 128x128
        
    if nargin < 3
        nd_ctt = 512/15;
    end
    
    [m n p]    = size(input_image);
    nm_ratio = n/m;
    
    Delta_final = round(strct.zli.Delta / strct.zli.reduccio_JW);
    
    mnew = nd_ctt*Delta_final; %m * (nd_ctt/(m/Delta_final));
    nnew = nd_ctt*Delta_final; %n * (nd_ctt/(n/Delta_final));
    
    m_resiz    = round(mnew);
    n_resiz    = round(nnew*nm_ratio);
    
    input_image_resized = imresize(input_image, [m_resiz n_resiz]);   
    
end
 
 
