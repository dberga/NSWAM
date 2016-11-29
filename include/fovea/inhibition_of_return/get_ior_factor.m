 function [ factor ] = get_ior_factor( time, max_time, iter, max_iter  )
     factor = 1./(exp((time ./ max_time)+((1./max_iter).*(iter ./ max_iter))));
 end
 
 