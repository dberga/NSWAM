
function [input_image_resized] = autoresize_nd(input_image,strct,nd_ctt)
     %nd_ctt = La constant (numero de neurones de matcon.) es specific size/window
        %exemple:
        %if width=1024,Delta=15,ctt=10 -> width_new = 15*2*10
        
    if nargin < 3
        nd_ctt = 1024/(15*2);
    end
    
    [m n p]    = size(input_image);
    nm_ratio = n/m;
    
    Delta_final = round(strct.zli_params.Delta / strct.zli_params.reduccio_JW);
    Delta_final = Delta_final * 2; %radius to diameter

    mnew = nd_ctt*Delta_final; %m * (nd_ctt/(m/Delta_final));
    nnew = nd_ctt*Delta_final; %n * (nd_ctt/(n/Delta_final));
    
    if nm_ratio > 1
        m_resiz    = round(mnew/nm_ratio);
        n_resiz    = round(nnew);
    
    else
        m_resiz    = round(mnew);
        n_resiz    = round(nnew*nm_ratio);
    end
    
    input_image_resized = imresize(input_image, [m_resiz n_resiz]);   
    
end
 
 
