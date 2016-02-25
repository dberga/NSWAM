function [ e, theta] = get_coord_props( x,y,xcenter,ycenter,M,N, vAngle)



                

                x_rel = xcenter-x;
                y_rel = ycenter-y;
                r = sqrt(x_rel^2 + y_rel^2);
                
                %cartesian to polar
                    [theta,rho] = cart2pol(x_rel,y_rel);
                        %%theta = atan(y_rel/x_rel);
                        %%rho = sqrt(x_rel^2 + y_rel^2);                      
                        max_r = sqrt(M^2 + N^2);
                        e = (rho/max_r)*vAngle;
                        
                        %%change range (per desplaçar indexes)
                            theta = mod(theta+4*pi,2*pi);
                            %e = mod(e+4*pi,2*pi);
                        %%to angles
                            theta = theta*(180/pi);
                            %e = e*(180/pi);
                

 
                
end

