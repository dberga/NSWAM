function bandCode
shiftAmount=0.5;
thetaPos=linspace(0,pi,100);



%linear
shifter=(thetaPos/-pi+1)*2;
shifter(shifter>1)=1;
shifter=shifter*shiftAmount;
figure (10); clf;hold on;
plot(shifter,'r'); plot(thetaPos,'k')
shifter=sqrt((thetaPos/-pi+1)*2);
shifter(shifter>1)=1;
shifter(50)
plot(shifter,'b');

%curved:


