
function ImagenSAL = zhong2012(bmap,W)

    % Mas información de los parámetros del filtro en \cite{Zhong2012} pp. 1065
    % Parámetros de la gaussiana ... (Cuántos pixels corresponden a 1 grado de angulo visual?. 40 pixels)
    if nargin < 2, W=40; end
    % Si queremos ser puristas ...
    sigval=W/(2*sqrt(2*log(2)));
    % Dimensiones de la ventana bidimensional ...
    sigwin = [round(6*sigval) round(6*sigval)];    

   
    smh = mat2gray(filter2(fspecial('gaussian',sigwin,sigval),bmap));
    %if ( strcmp(class(smh),'double') ), smh = uint8(smh); end

    ImagenSAL=smh;

end
