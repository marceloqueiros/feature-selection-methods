function F = SPAproject(X,y,A,fold,method,Nmin,Nmax)
%Successive Projections Algorithm
%Last update: 02/05/2017

%X: matriz de dados m x p
%y: vetor de saída
%A: the maximal principle to extract
%fold: the group number for cross validation 
%method: metodo de pre tratamento.
%num: the  number of Monte Carlo Sampling runs.
tic;
if nargin<7;Nmax=20;end;
if nargin<6;Nmin=15;end;
if nargin<5;method='center';end;
if nargin<4;fold=5;end;
if nargin<3;A=2;end;
%+++ Initial settings.
[Mx,Nx]=size(X); %matriz de tamanho Mx por Nx, com Mx sendo a altura
A=min([Mx Nx A]); %se Mx ou Nx for menor que A, A fica com esse valor

J=Nx;
SPAtotais = (Nmax-Nmin+1)*J;   %numero de todos os SPA feitos
%nn=Nmax-Nmin+1;

Px=zeros(210,J);       %projecoes

k=zeros(SPAtotais,Nmax);  %variaveis selecionadas
%s=zeros(1,nn);
%r=zeros(1,nn);
%Q2=zeros(1,J);
%cv
%RMSEP=zeros(SPAtotais,num); %criar vetor RMSEP
%Rpc=zeros(1,num);
fprintf('Inicio SPA:\n');
%passo0
%Xcal=X;
%Xcal(:,j) representa a coluna j
%contador=0;    %necessário para indexar SPA
SPAatual=0;
for N = Nmin:Nmax       %testar vários Ns
    fprintf('N = %d\n', N);
    for initial=1:J     %testar cada wave como k(0) 
        SPAatual = SPAatual+1;%+(N-Nmin+1)*initial;%+(J*contador);
        k(SPAatual,1)=initial;
        S=1:1:1040;
        Xcal=X;
        for n=2:N       %SPA
            %passo1
            %if(n>1) 
            %    S(n-1)=0; %n-1 já foi selecionada 
            %end
            %em baixo
            %passo2
            Pxmedia=zeros(1,J);
            for j=1:J
                Px(:,j) = Xcal(:,j) - ( Xcal(:,j)' * Xcal(:,k(SPAatual,n-1)) ) * Xcal(:,k(SPAatual,n-1)) * ( Xcal(:,k(SPAatual,n-1))' * Xcal(:,k(SPAatual,n-1)) )^(-1);
                Pxmedia(1,j)=mean(abs(Px(:,j)));
            end
            
            %passo3
            %k = coluna com maior projeção
            flag=1;
            while (flag==1)
                [argvalue, k(SPAatual,n)] = max(Pxmedia(1,:));  %seleção
                %caso seja 0 significa que já foi selecionada e vai
                %selecionar outra
                if(S(k(SPAatual,n))==0)
                    Pxmedia(1,k(SPAatual,n)) = 0; %o máximo será outro 
                else
                    flag=0;
                end
            end
            %passo1
            %depois de selecionar indicar que já foi selecionada (igualar S a 0)
            S(k(SPAatual,n)) = 0;  
            
            %passo4
            for j=1:J
                Xcal(:,j)=Px(:,j);
                %S=find(Px(:,j)~=0);  %j pertencentes a S  
            end
            
            %PLS=pls(Xcal,y,A,method);    %+++ PLS model
        
            %CV=plscvfold(Xcal,y,A,fold,method,0);  
            %Q2(initial)=CV.Q2_max; 
            %p(initial)=CV.RMSECV;  %p=RMSE    
        end
        fprintf('Initial = %d, N = %d\n', initial, N);
    end
    %contador=contador+1;
end
fprintf('Cross-Validation...\n');
p=zeros(1,SPAtotais);  %rmse
Q2_max=zeros(1,SPAtotais);
Rpc=zeros(1,SPAtotais);
for i=1:SPAtotais
    Knonzeros=find(k(i,:)~=0);
    indices=sort(k(i,Knonzeros));
    
    CV=plscvfold(X(:,indices),y,A,fold,method,0);
    p(i)=CV.RMSECV;
    Q2_max(i)=CV.Q2_max;
    Rpc(i)=CV.optPC;
end
    %Q2_max(SPAatual)=CV.Q2_max;
    %Niter=N-Nmin+1;
    
    %RMSE SPA
    %FUNÇÃO OBJETIVO: RMSE
    %r(SPAatual)= min(p);  %p(initial), initial = 1:J
    
    %s(niter)= coluna com menor RMSE
    %[argvalue2, s(SPAatual)] = min(p);  %s(N)= arg(min(p));

%N = N com menor RMSE
[pmin, N] = min(p);  %r(N), N=Nmin:Nmax
Knonzeros=find(k(N,:)~=0);
%k(N,1)=s(N);
%Q2_N = Q2_max(N);  %max do Q2
%+++ save results;
time=toc;
%+++ output
F.time=time;
F.vsel=sort(k(N,Knonzeros));
F.minRMSECV=pmin;
F.Q2_N=Q2_max(N);
F.linhaselecionada=N;
F.kSORT=sort(k,2);
F.k=k;
F.RMSECV_ALL=p;
F.Q2_N_ALL=Q2_max;
F.optPC=Rpc(N);
fprintf('SPA completo.\n');