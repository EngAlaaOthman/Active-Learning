% This function calculates some classification metrics (e.g. accuracy, sensitivity, and specificity)
%% Inputs ----------------------
% 1-Targets: The original targets/class labels of the samples in data   
% 2-Predictions: The class labels of the samples in data   
% 3-C : The set of classes
% 2-data:    The current data (each sample is a column)

%% Outputs ----------------------
% 1-Results : The results of the classification

function Results= CalculateClassificationScores(Targets, Predictions,C)
% Try to make a confusion matrix
idxTrue=Predictions==Targets;
for j=1:numel(C) % true labels
    idxt=Targets==C(j);            
    ConfMat(j,j)=sum(idxt.*idxTrue);
end
clear idxTrue;
for j=1:numel(C)
    for k=1:numel(C)
        if j==k
            continue;
        else
            idxp=Predictions==C(j); % found class in the predictions
            idxt=Targets==C(k); 
            ConfMat(j,k)=sum(idxp.*idxt);            
        end
    end
end

for j=1:numel(C)
    TP(j)=ConfMat(j,j);
    idx=(1:numel(C))~=j;
    FN(j)=sum(ConfMat(idx(:),j)) ;                     
    FP(j)=sum(ConfMat(j,idx(:))) ;                     
    TN(j)=sum(sum(ConfMat(idx(:),idx(:))));           
    TPR(j)=TP(j)/(TP(j)+FN(j)); % sensitivity
    TNR(j)=TN(j)/(TN(j)+FP(j)); % Specificity 
    GM(j)=sqrt(TPR(j)*TNR(j));
    Acc(j)= (TP(j)+TN(j))/(TP(j)+TN(j)+FN(j)+FP(j))  ;
end
clear ConfMat TP idx FN FP TN TPR TNR 
idx=isnan(Acc);
Results.Acc=mean(Acc(~idx));
idx=isnan(GM);
Results.GM=mean(GM(~idx));

