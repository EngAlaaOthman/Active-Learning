% This function for generating a set of weak learners based on the current
% labeled data (Dl)
%% Inputs ------------------------
% 1-data ((d+1)xnl): The current labeled data
% 2-Targets: The targets of the selected instances
% 3-Nc: The total number of the generated classifiers
% 4-dim: Dimension of the space

%% Outputs ---------------------
% 1-FinalModel: The generated hypotheses

function [FinalModel,Acc]=GenerateMLPClassifiers(data, Targets, Nc,dim)
[~,c]=size(data);
AcceptedPer=0.5;
FinalModel=[]; % The weights after the training and after excluding the weights of the classifiers that misclassify any object
counter=1; Trials=0;
while counter<=Nc
    Per=randperm(c);
    Newdata=data(:,Per);
    NewTargets=Targets(:,Per);
    Newdata=Newdata(:,1:ceil(0.8*c));
    NewTargets=NewTargets(:,1:ceil(0.8*c));
    idx=NewTargets==-1; NewTargets(idx)=2;
    % Build the prediction model
    Mdl = mlp_train(Newdata(1:dim,:)', NewTargets',10,150);
    Outs=Newdata(1:dim,:)';
    for j=1:size(Outs,1)
        Temp2(j) = mlp_classify(Mdl,Outs(j,:));
    end
    Acc(counter)=sum(Temp2==NewTargets)/size(NewTargets,2);
    if Acc(counter)>AcceptedPer
        FinalModel{counter}=Mdl;
        counter=counter+1;
    end
    Trials=Trials+1;
    if Trials==Nc*10
        %AcceptedPer=AcceptedPer-0.1;
        %Trials=0;
        break;
    end
end