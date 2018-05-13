%%
%MONTE CARLO TESTES
%usar os varios testes
% x1=a50.RMSECV_all
% x2=a100.RMSECV_all
% x3=a200.RMSECV_all
% x4=a500.RMSECV_all
% x5=a1000.RMSECV_all
% C = [x1 x2 x3 x4 x5];
% grp = [zeros(1,50),ones(1,100), 2*ones(1,200),3*ones(1,500),4*ones(1,1000)];
% figure
% boxplot(C,grp,'Labels',{'50','100','200','500','1000'})
% xlabel('Monte Carlo sampling runs')
% ylabel('RMSECV')

%%
%RMSE VS NUM VARS SPA
% figure()
% hold on
% S=zeros(1,102960);
% for i=1:102960
%     kn=find(Result.k(i,:)~=0);
%     S(i)=numel(kn);
% end
% plot(S,Result.RMSECV_ALL,'.','linewidth', 1)
% plot(17,1.091992688414810,'.r','linewidth', 2)
% xlabel('Variable Number')
% ylabel('RMSECV')
% hold off

%%
%RMSE VS NUM VARS CARS
% figure()
% hold on
% plot(cars.NumeroVariaveisAll,cars.RMSECV_all,'d')
% plot(77,0.582005566876979,'dr','linewidth', 1)
% plot(44,[0.660827268040320],'dg','linewidth', 1)
% xlabel('Variable Number')
% ylabel('RMSECV')
% hold off
%%
%FREQUENCY NUM VARS CARS
% histogram(cars.NumeroVariaveisAll)
% xlabel('Variable Number')
% ylabel('Frequency')
% hold off

%%
%r quadrado cars vs spa
% cars=ResultBootStrap;
% spa=Result;
% 
% figure()
% hold on
% 
% plot(cars.NumeroVariaveisAll,cars.Q2_all,'.')
% 
% S=zeros(1,102960);
% for i=1:102960
%     kn=find(Result.k(i,:)~=0);
%     S(i)=numel(kn);
% end
% plot(S,spa.Q2_N_ALL,'.','linewidth', 1)
% xlabel('Variable Number (N)')
% ylabel('Pearson Coefficient (R²)')
% plot(77,0.969381724276501,'or','linewidth', 1)
% plot(44,0.960526797493914,'og','linewidth', 1)
% plot(17,0.892213116961390,'ob','linewidth', 1)
% legend('CARS', 'SPA','Location', 'southoutside')
% 
% hold off