% This function to load the dataset
% X: data points (N x dim), N no. of points, dim is the dimension
% Y: class labels (N x 1)
% ClassNames: names of unique class labels 
% N: no. of data points
% dim: dimensions of the data 
% Lb: lower boundary of the feature space
% Ub: upper boundary of the feature space

function [X,Y,ClassNames,C,N,dim,Lb,Ub]=LoadData(PlotFlag)
%
load fisheriris;
Y=[ones(1,50) 2*ones(1,50) 3*ones(1,50)]';
% use only two dimensions for visualization
X = meas(:,3:4);
if PlotFlag==1
    plot(X(Y==1,1),X(Y==1,2),'bx','MarkerSize',16, 'LineWidth',3); hold on % First class
    plot(X(Y==2,1),X(Y==2,2),'gx','MarkerSize',16, 'LineWidth',3); hold on % First class
    plot(X(Y==3,1),X(Y==3,2),'rx','MarkerSize',16, 'LineWidth',3); hold on % First class
    legend('Class 1','Class 2','Class 3')
    set(gca,'fontsize', 20);
    set(gcf,'color','w');
end
ClassNames=unique(Y);         
C=numel(ClassNames); % number of classes
[N,dim]=size(X);
% find the upper and lower limits
for i=1:dim
    Lb(i)=min(X(:,i));
    Ub(i)=max(X(:,i));  
end