function EscriuRGB2BINReal(Imatge,NomArxiu)


for i=1:3
    Nom=sprintf('%s%d.img',NomArxiu,i);
    f=fopen(Nom,'wb');
    fwrite(f,Imatge(:,:,i),'single');
    fclose(f);
end

