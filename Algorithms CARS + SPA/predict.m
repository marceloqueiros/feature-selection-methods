function F=predict(Xtrain,Ytrain,Xtest,Ytest,selected_variables,A_max,fold,method)

%++ prediction with the selected variables
%+++ Xtrain: The training data matrix (m1 x n)
%+++ Ytrain: The reponse vector of training data (m1 x 1)
%+++ Xtest: The test data matrix (m2 x n)
%+++ Ytest: The reponse vector of test data (m2 x 1)
%+++ selected_variables: the selected optimal variable subset
%+++ A_max: the maximal principle to extract.
%+++ fold: the group number for cross validation.
%+++ method: pretreatment method.
%+++ Yonghuan Yun, Dec.15, 2013. yunyonghuan@foxmail.com

if nargin<8;method='center';end;
if nargin<7;fold=10;end;
if nargin<6;A_max=10;end;


Xtrain=Xtrain(:,selected_variables);
Xtest=Xtest(:,selected_variables);
CV=plscvfold(Xtrain,Ytrain,A_max,fold,method);
A_opt=CV.optPC; 
PLS=pls(Xtrain,Ytrain,A_opt,method);
Xtest_expand= [Xtest ones(size(Xtest,1),1)];
coef=PLS.coef_origin;
ypred=Xtest_expand*coef(:,end);
SST_R=sum((Ytest-mean(Ytest)).^2);  
SSE_F=sum((Ytest-ypred).^2); 
RMSEC=sqrt(PLS.SSE/size(Xtrain,1));
RMSEP=sqrt(sum((Ytest-ypred).^2)/size(Xtest,1));

% Result
F.PLS = PLS;
F.ypred=ypred;
F.OptPC=A_opt;
F.CV=CV;
F.RMSEP=RMSEP;
F.RMSEC=RMSEC;
F.R2=PLS.R2;
F.Q2_cv=CV.Q2_max;
F.Q2_ext=1-SSE_F/SST_R;

