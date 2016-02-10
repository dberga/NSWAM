% about the mean value of I_norm

a=vector_I_norm;

figure;plot(a(1,:),'r');
hold on;plot(a(2,:),'g');
hold on;plot(a(3,:),'b');
hold on;

disp('mean I_norm')
mean(a(3,:))