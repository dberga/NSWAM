function [ X_out, Y_out ] = movecoords( M_in, N_in, X_in, Y_in , M_out, N_out)
    X_rel = X_in/N_in;
    Y_rel = Y_in/M_in;
    
    X_out = round(X_rel*N_out);
    Y_out = round(Y_rel*M_out);

end

