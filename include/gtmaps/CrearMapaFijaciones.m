% Construye un mapa de atenci�n a partir de las posiciones de las fijaciones ...
%
%       Par�metros:
%           Entrada:
%                   ListaFijaciones: Vector de posiciones XY donde ha fijado el sujeto
%                   ImagenVACIA: Imagen con las dimensiones deseadas donde se a�adir�n las fijaciones
%           Salida: ---
%
function ImagenSAL = CrearMapaFijaciones(ListaFijaciones,ImagenVACIA)

    % Mas informaci�n de los par�metros del filtro en \cite{Zhong2012} pp. 1065
    % Par�metros de la gaussiana ... (Cu�ntos pixels corresponden a 1 grado de angulo visual?. 40 pixels)
    W=40;
    % Si queremos ser puristas ...
    sigval=W/(2*sqrt(2*log(2)));
    % Dimensiones de la ventana bidimensional ...
    sigwin = [round(6*sigval) round(6*sigval)];    
    alpha=1;

    numFix=size(ListaFijaciones,1);
    for indFIX=1:numFix
        datosFIX=ListaFijaciones(indFIX,:);
        if( round(datosFIX(2))>0 && round(datosFIX(1))>0 && round(datosFIX(2))<240 && round(datosFIX(1))<320)
            ImagenVACIA(round(datosFIX(2)),round(datosFIX(1)))= ImagenVACIA(round(datosFIX(2)),round(datosFIX(1)))+ ...
                                                                                    (alpha*round(datosFIX(4))+(1-alpha));
        end
    end
    smh = mat2gray(filter2(fspecial('gaussian',sigwin,sigval),ImagenVACIA));
    if ( strcmp(class(smh),'double') ), smh = uint8(smh * 255); end

    ImagenSAL=smh;

end
