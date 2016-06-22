V1Areas=zeros(quadPerRing,numOfRings);
V2Areas=zeros(quadPerRing,numOfRings);
V3Areas=zeros(quadPerRing,numOfRings);
visFieldArea=zeros(quadPerRing,numOfRings);
XX=[]; YY=[]; %clear the old anisotropy delauney
for thisRing=1:length(rings)


    %now plot and compute the quads in the visual field
    for thisQuad=0:quadPerRing-1
        %         polar(squares(2,pointOrder+thisQuad*2,thisRing),squares(1,pointOrder,thisRing));
        [xc,yc]=pol2cart(squares(2,pointOrder+thisQuad*2,thisRing),squares(1,pointOrder,thisRing));

        visFieldArea(thisQuad+1,thisRing)=QuadrilateralArea([xc(1:4);yc(1:4)]);
    end

    [V1quad,V2quad,V3quad,V4quad]=assembleV1V4DLOComplex(squares(:,:,thisRing),[V1linShear,V2linShear,V3linShear],0);


    eval(['[V1cartx,V1carty]=',model,'(V1quad,a,b);']);
    eval(['[V2cartx,V2carty]=',model,'(V2quad,a,b);']);
    eval(['[V3cartx,V3carty]=',model,'(V3quad,a,b);']);
    
    for thisQuad=1:quadPerRing
        thisCoords=[1:4]+(thisQuad-1)*2;
        V1Areas(thisQuad,thisRing)=QuadrilateralArea([V1cartx(thisCoords);V1carty(thisCoords)]);
        V1XPos(thisQuad,thisRing)=mean(V1cartx(thisCoords));
        V1YPos(thisQuad,thisRing)=mean(V1carty(thisCoords));
        if thisQuad~=(quadPerRing/2)+1
            V2Areas(thisQuad,thisRing)=QuadrilateralArea([V2cartx(thisCoords);V2carty(thisCoords)]);
            V2XPos(thisQuad,thisRing)=mean(V2cartx(thisCoords));
            V2YPos(thisQuad,thisRing)=mean(V2carty(thisCoords));
            V3Areas(thisQuad,thisRing)=QuadrilateralArea([V3cartx(thisCoords);V3carty(thisCoords)]);
            V3XPos(thisQuad,thisRing)=mean(V3cartx(thisCoords));
            V3YPos(thisQuad,thisRing)=mean(V3carty(thisCoords));
        else
            xx=[V1cartx(end:-1:end-1),V2cartx(thisCoords(3:4))];
            yy=[V1carty(end:-1:end-1),V2carty(thisCoords(3:4))];
            V2Areas(thisQuad,thisRing)=QuadrilateralArea([xx;yy]);
            V2XPos(thisQuad,thisRing)=mean(xx);
            V2YPos(thisQuad,thisRing)=mean(yy);
            xx=[V2cartx(end:-1:end-1),V3cartx(thisCoords(3:4))];
            yy=[V2carty(end:-1:end-1),V3carty(thisCoords(3:4))];
            V3Areas(thisQuad,thisRing)=QuadrilateralArea([xx;yy]);
            V3XPos(thisQuad,thisRing)=mean(xx);
            V3YPos(thisQuad,thisRing)=mean(yy);
        end
    end

end