function F = CARSproject(X,y,A,fold,method,num)
%X: matriz de dados m x p
%y: vetor de saída
%A: the maximal principle to extract
%fold: the group number for cross validation 
%method: metodo de pre tratamento.
%num: the  number of Monte Carlo Sampling runs.
tic;
%+++ Initial settings.
if nargin<6;num=50;end;
if nargin<5;method='center';end;
if nargin<4;fold=5;end;
if nargin<3;A=2;end;
%+++ Initial settings.
[Mx,Nx]=size(X); %matriz de tamanho Mx por Nx, com Mx sendo a altura
A=min([Mx Nx A]); %se Mx ou Nx for menor que A, A fica com esse valor
index=1:Nx; %index = 1 2 3 4...Nx
ratio=0.9; %rácio do Q
r0=1;
r1=2/Nx; 
Vsel=1:Nx; %Vsel = 1 2 3 4...Nx
Q=floor(Mx*ratio); %Q = 90% do valor de Mx (arredonda ao inteiro abaixo)
W=zeros(Nx,num); %matriz de zeros com dimensão Nx x num
Ratio=zeros(1,num); %vetor de zeros com tamanho num

%+++ Parameter of exponentially decreasing function.  EDF
b=log(r0/r1)/(num-1);  
a=r0*exp(b);

%+++ Main Loop
for iter=1:num
     perm=randperm(Mx); %exemplo:  6     3     7     8     5     1     2     4  max: Mx
     Xcal=X(perm(1:Q),:); %+++ Monte-Carlo Sampling.
     ycal=y(perm(1:Q));   %+++ Monte-Carlo Sampling.
     %Q tem menos dimensão que perm/Mx
     %X é a matriz original
     %y é o vetor de saída
     %Xcal será a imagem dos Mx aleatórios para a matriz X
     %ycal será a imagem dos Mx aleatórios para o vetor y(estará vazio de inicio)
     
     PLS=pls(Xcal(:,Vsel),ycal,A,method);    %+++ PLS model
     %Vsel = contém os valores da amostra anterior
     %Xcal 
   
     w=zeros(Nx,1);
     coef=PLS.coef_origin(1:end-1,end);
     w(Vsel)=coef;
     W(:,iter)=w; %a coluna iter fica com o vetor w
     %W é a matriz que guarda os vetores w
     w=abs(w);                          %+++ weights
     [ws,indexw]=sort(-w);              %+++ sort weights
     %ordena, as piores ficam no fim e serão removidas - K é a fronteira
     %b é parametro do edf
     ratio=a*exp(-b*(iter+1));          %+++ Ratio of retained variables.
     Ratio(iter)=ratio; %vetor que guarda os vários ratios
     K=round(Nx*ratio); %arredonda ao inteiro acima - K é a nova largura
     
     w(indexw(K+1:end))=0;              %+++ Eliminate some variables with small coefficients.  
     
     %ARS
     Vsel=randsample(Nx,Nx,true,w);     %+++ Reweighted Sampling from the pool of retained variables.                 
     Vsel=unique(Vsel); %retorna o Vsel sem repetições e ordenados- eliminar redundancia            
     %fprintf('The %dth variable sampling finished.\n',iter);    %+++ Screen output.
end

%+++  Cross-Validation to choose an optimal subset;
RMSEP=zeros(1,num); %criar vetor RMSEP
Q2_max=zeros(1,num);
Rpc=zeros(1,num);
for i=1:num
   vsel=find(W(:,i)~=0);
 
   CV=plscvfold(X(:,vsel),y,A,fold,method,0);
   RMSEP(i)=CV.RMSECV;
   Q2_max(i)=CV.Q2_max;
   
   Rpc(i)=CV.optPC;
   %fprintf('The %d/%dth subset finished.\n',i,num);
end
[Rmin,indexOPT]=min(RMSEP);
Q2_max=max(Q2_max);


%+++ save results;
time=toc;
%+++ output
F.RMSECV_all=RMSEP;
F.W=W;
F.time=time;
F.cv=RMSEP;
F.Q2_max=Q2_max;
F.minRMSECV=Rmin;
F.iterOPT=indexOPT;
F.optPC=Rpc(indexOPT);
F.ratio=Ratio;
F.vsel=find(W(:,indexOPT)~=0)';

function sel=weightsampling_in(w)
%Bootstrap sampling
%2007.9.6,H.D. Li.

w=w/sum(w);
N1=length(w);
min_sec(1)=0; max_sec(1)=w(1);
for j=2:N1
   max_sec(j)=sum(w(1:j));
   min_sec(j)=sum(w(1:j-1));
end
% figure;plot(max_sec,'r');hold on;plot(min_sec);
      
for i=1:N1
  bb=rand(1);
  ii=1;
  while (min_sec(ii)>=bb || bb>max_sec(ii)) && ii<N1;
    ii=ii+1;
  end
    sel(i)=ii;
end      % w is related to the bootstrap chance

%+++ subfunction:  booststrap sampling
% function sel=bootstrap_in(w);
% V=find(w>0);
% L=length(V);
% interval=linspace(0,1,L+1);
% for i=1:L;
%     rn=rand(1);
%     k=find(interval<rn);
%     sel(i)=V(k(end));    
% end

%%
% xaxis = roundn([380:0.6231:1028],-1);