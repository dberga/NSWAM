function [ margin_up, margin_down, margin_left, margin_right ] = calc_padding_margins( input_image , ifix, jfix, vAngle , lambda )

[M,N,C] = size(input_image);
m_half = round(M/2);
n_half = round(N/2);

%%CORTAR A ESQUINAS
%1,N
%M-1,N
%M,1
%M,N-1

%%CORTAR A BORDES
%1,n_half
%M-1,n_half
%m_half,1
%m_half,N-1

[amax_up_margin,emax_up_margin] = vPixel2vAngle(1,n_half,ifix,jfix,M,N,vAngle);
[amax_down_margin,emax_down_margin] = vPixel2vAngle(M-1,n_half,ifix,jfix,M,N,vAngle);
[amax_left_margin,emax_left_margin] = vPixel2vAngle(m_half,1,ifix,jfix,M,N,vAngle);
[amax_right_margin,emax_right_margin] = vPixel2vAngle(m_half,N-1,ifix,jfix,M,N,vAngle);

[amag_up_margin,emag_up_margin] = vAngle2rAngle(amax_up_margin,emax_up_margin, lambda);
[amag_down_margin,emag_down_margin] = vAngle2rAngle(amax_down_margin,emax_down_margin, lambda);
[amag_left_margin,emag_left_margin] = vAngle2rAngle(amax_left_margin,emax_left_margin, lambda);
[amag_right_margin,emag_right_margin] = vAngle2rAngle(amax_right_margin,emax_right_margin, lambda);

ediff_up = emag_up_margin - emax_up_margin;
ediff_down = emag_down_margin - emax_down_margin;
ediff_left = emag_left_margin - emax_left_margin;
ediff_right = emag_right_margin - emax_right_margin;

[row_up_margin,~] = rAngle2rPixel(amag_up_margin,ediff_up,ifix, jfix, M, N, vAngle);
[row_down_margin,~] = rAngle2rPixel(amag_down_margin,ediff_down,ifix, jfix, M, N, vAngle);
[~,col_left_margin] = rAngle2rPixel(amag_left_margin,ediff_left,ifix, jfix, M, N, vAngle);
[~,col_right_margin] = rAngle2rPixel(amag_right_margin,ediff_right,ifix, jfix, M, N, vAngle);

margin_up = round(abs(row_up_margin));
margin_down = round(abs(abs(row_down_margin) - M));
margin_left = round(abs(col_left_margin));
margin_right = round(abs(abs(col_right_margin) - N));



end

