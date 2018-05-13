%% Main program para selecção de variaveis
% Last update: 02/05/2017

clear; close all; clc;

DirInicial = pwd;

%usar o SPA

A_max=20;
fold=7;
method='center';
nmin=2;
nmax=100;

load('Hyper2012_AllData.mat');

X=MeanROffPedNorm';
Y = Desired(:,2); %Referente aos Açucares

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

Result=SPAproject(Xtreino,Ytreino,A_max,fold,method,nmin,nmax);
save('C:\Users\Marcelo Queirós\Desktop\testes spa cars\SPATeste.mat');
cd(DirInicial)
