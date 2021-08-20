% The goal of this function is to calculate the classification performance
% of the active learner. The active learner selects some instances for
% labeling them and the rest are the test instances
%% Inputs -------------------
% 1- Data:      The patterns of the whole data
% 2- Labels:    The labels of the whole data
% 3- idxFinal:  The index of the selected instances to be the training
% data, and the rest are the test data

%% Outputs ------------------
% 1- A:      The average of the accuracy, sensitivity, and specificity of
% all classes

function [Results,ExpectedUncertainities]= CalculateSenSpecMulti(Data, Labels, OuridxFinal, Threshold)
TrainingPatterns=Data(:,OuridxFinal);
TrainingLabels=Labels(OuridxFinal);
ClassNames=unique(TrainingLabels);
Testpatterns=Data(:,~OuridxFinal);
TestLabels=Labels(~OuridxFinal);
ExpectedUncertainities=zeros(size(TestLabels,1));
Results.Sen=0;    Results.Spec=0;    Results.Acc=0;
if numel(ClassNames)==1 % one class
%     SVMModel = fitcsvm(TrainingPatterns',TrainingLabels);
%     [Predictions,score] = predict(SVMModel,Testpatterns');
%     Temp=score<=-Threshold; %% away points (from the another class)
%     OutputLabels=~Temp.*Predictions;
%     IDX=TestLabels==ClassNames;
%     Accuracy=sum(OutputLabels(IDX)==TestLabels(IDX))*100/sum(IDX);
Accuracy=0;
      
elseif numel(ClassNames)==2 % binary class                    
%     cl = fitcsvm(TrainingPatterns',TrainingLabels,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',ClassNames');
           
    %PlotSVMDecisionBoundaries(LabeledPoints,LabeledLabels,cl)
    %SVMModel = fitcsvm(LabeledPoints,LabeledLabels);
%       [FinalPredictions,ExpectedUncertainities]=OurClassifierRUSBoost(TrainingPatterns, TrainingLabels, Testpatterns);
      
%       t = templateTree('MaxNumSplits',numel(TrainingLabels));
%       rusTree = fitcensemble(TrainingPatterns',TrainingLabels,'Method','RUSBoost','NumLearningCycles',1000,'Learners',t,'LearnRate',0.1,'nprint',100);
      [FinalPredictions,ExpectedUncertainities]=OurClassifier2(ClassNames, TrainingPatterns, TrainingLabels, Testpatterns);
%       [FinalPredictions,ExpectedUncertainities]=OurClassifierMlp(ClassNames, TrainingPatterns, TrainingLabels, Testpatterns);
%       [FinalPredictions,ExpectedUncertainities]=OurClassifierMlpSort(ClassNames, TrainingPatterns, TrainingLabels, Testpatterns);
%       confusionmat(FinalPredictions,TestLabels)
%       confusionmat(FinalPredictionsMlp,TestLabels)
      OutputLabels=FinalPredictions;
      for kk=1:numel(ClassNames) 
        IDX=TestLabels==ClassNames(kk);
        Accuracy(kk)=sum(OutputLabels(IDX)==TestLabels(IDX))*100/sum(IDX);        
      end 
else % multiclass    
    SVMModel = fitcecoc(TrainingPatterns,TrainingLabels);
%     cl = fitcsvm(X,yTrain,'KernelFunction','rbf', 'KernelScale', Sigma, 'BoxConstraint',C,'ClassNames',[-1,1]);
    [Predictions,~] = predict(SVMModel,Testpatterns);
    OutputLabels=Predictions;
    TotalAccuracy=sum(OutputLabels==TestLabels)*100/size(Testpatterns,1);
    for kk=1:numel(CC)
        IDX=TestLabels==ClassNames(kk);
        Accuracy(kk)=sum(OutputLabels(IDX)==TestLabels(IDX))*100/sum(IDX);
    end
end
if numel(ClassNames)>1 % binary or multplie classes
    TotalAccuracy=sum(OutputLabels==TestLabels)*100/size(Testpatterns',1);
    Results.TotalAccuracy=TotalAccuracy;
    Results.Accuracy=Accuracy;
    idxTrue=OutputLabels==TestLabels;
    ConfMat = confusionmat(OutputLabels,TestLabels);    
    if numel(ClassNames)==2
        TP=ConfMat(1,1);
        TN=ConfMat(2,2);
        FP=ConfMat(1,2);
        FN=ConfMat(2,1);
        TPR=TP/(TP+FN); % sensitivity
        TNR=TN/(TN+FP); % Specificity 
        GM=sqrt(TPR*TNR);
        Acc= (TP+TN)/(TP+TN+FN+FP)  ;
        Results.Sen=TPR;
        Results.Spec=TNR;
        Results.Acc=Acc;    
    elseif numel(ClassNames)>2
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
        Results.Sen=mean(TPR);
        Results.Spec=mean(TNR);
        Results.Acc=mean(Acc);
    end
end
if ClassNames==1 % minority class
    Results.Sen=0;
    Results.Spec=0;
    Results.Acc=0;
end