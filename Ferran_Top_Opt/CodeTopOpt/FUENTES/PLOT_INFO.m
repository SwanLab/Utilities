function [] = PLOT_INFO(n,ini_incre,end_incre)

% ptje_reducc : porcentaje de reduccion de la masa frente a la inicial

% plot variables auxiliares
load('vtheta.mat','vtheta');
color = {'r', 'b' ,'g' ,'y' ,'k' ,'m' ,'c'};
for incre=ini_incre:end_incre
    iplot = incre -ini_incre +1;
x1 = vtheta(incre,2:n,1); % kiter
cost = vtheta(incre,2:n,2); % valores de kappa
theta = vtheta(incre,2:n,3);
kappa = vtheta(incre,2:n,4);
vol = vtheta(incre,2:n,5);
h_C = vtheta(incre,2:n,6);
L_vol = vtheta(incre,2:n,7);
figure(1);
hold on;
text = ['EVOLUCION DE J: STEP: ' num2str(incre)];
title(text);
xlabel('VARIACION DE KAPPA');
ylabel('COST FUNCTION');
plot(kappa,cost,color{iplot});
%plot(kappa,h_C);
%plot(kappa,L_vol,'-r');
hold off;
figure(2);
hold on;
text = ['EVOLUCION DE THETA: STEP: ' num2str(incre)];
title(text);
xlabel('VARIACION DE KAPPA');
ylabel('ANGLE THETA');
plot(kappa,theta,color{iplot});
hold off;

figure(3);
hold on;
text = ['EVOLUCION DEL VOL: STEP: ' num2str(incre)];
title(text);
xlabel('VARIACION DE KAPPA');
ylabel('VOLUME OMEGA1');
plot(kappa,vol,color{iplot});
% factor = (1-ptje_reducc/100);
% volref = vol(1)*ones(1,n-1)*factor;
% plot(kappa,volref,'-r');

hold off;
end