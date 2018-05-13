%% Main program para selecção de variaveis
% Last update: 23/04/2017

clear; close all; clc;

DirInicial = pwd;
tic;
%usar o CARS

A_max=20;
fold=7;
method='center';
iter=200;
BootStrap = 1000;

load('Hyper2012_AllData.mat');

X=MeanROffPedNorm';
Y = Desired(:,2); % Referente aos Açucares


indtreino=1;
indteste=1;
N=240;
for i=1:8:N          %1 em cada 8 é teste
    for j=0:6
        Xtreino(indtreino, :) = X(i+j, :);
        Ytreino(indtreino,:) = Y(i+j,:);
        indtreino = indtreino + 1;
    end
    Xteste(indteste, :) = X(i+j+1, :);
    Yteste(indteste,:) = Y(i+j+1,:);
    indteste = indteste + 1;
end
% funcDir = ['C:\Users\Marcelo Queirós\Documents\MATLAB\CARS\VCPA 1.1']
% Dir = funcDir

%VECTselected_variables=zeros(num);
%VECTRMSECV=zeros(num);
%VECTQ2_max=zeros(num);
ResultBootStrap= struct;
ResultBootStrap.vselAll=zeros(num,1040);
for i=1:num
Result=CARSproject(Xtreino,Ytreino,A_max,fold,method,iter);
%selected_variables=Result.vsel;
%F=predict(Xtreino,Ytreino,Xteste,Yteste,selected_variables,A_max,fold,method);

[xx,yy]=size(Result.vsel);
%VECTselected_variables(i)=yy;
%VECTRMSECV(i)=Result.minRMSECV;
%VECTQ2_max(i)=Result.Q2_max;
ResultBootStrap.NumeroVariaveisAll(i)=yy;
ResultBootStrap.RMSECV_all(i)=Result.minRMSECV;
ResultBootStrap.Q2_all(i)=Result.Q2_max;

ResultBootStrap.iterOPTAll(i)=Result.iterOPT;
ResultBootStrap.optPCAll(i)=Result.optPC;

[y,x]=size(Result.vsel);
B = padarray(Result.vsel,[0 1040-x],'post');
ResultBootStrap.vselAll(i,:)=B;

fprintf('Iteração %d/%d.\n',i,num);
end
[ResultBootStrap.MinNumVariaveis, linha]=min(ResultBootStrap.NumeroVariaveisAll);
ResultBootStrap.LinhaMenosVariaveis=linha;
[ResultBootStrap.MinRMSECV, linha]=min(ResultBootStrap.RMSECV_all);
ResultBootStrap.LinhaMenorRMSECV=linha;
[ResultBootStrap.MaxR2,linha]=max(ResultBootStrap.Q2_all);
ResultBootStrap.LinhaMaiorR2=linha;
time=toc;
ResultBootStrap.time=time;
%save('C:\Users\Marcelo Queirós\Desktop\testes spa cars\CarsTeste.mat');
cd(DirInicial)
