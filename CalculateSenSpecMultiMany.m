% The goal of this function is to calculate the classification performance
% of the active learner. The active learner selects some instances for
% labeling them and the rest are the test instances. Here, we will use (Naive Bayes) NB
% classifier
%% Inputs -------------------
% 1- Data:      The patterns of the whole data
% 2- Labels:    The labels of the whole data
% 3- idxFinal:  The index of the selected instances to be the training
% data, and the rest are the test data

%% Outputs ------------------
% 1- Accuracy: The accuracy of the classification model

function [Accuracy]= CalculateSenSpecMultiMany(Data, Labels, OuridxFinal)
TrainingPatterns=Data(:,OuridxFinal);
TrainingLabels=Labels(OuridxFinal);
ClassNames=unique(TrainingLabels);
Testpatterns=Data(:,~OuridxFinal);
TestLabels=Labels(~OuridxFinal);
if numel(ClassNames)==1 % one class
      Accuracy=0;
elseif numel(ClassNames)==2 % binary class
    [FinalPredictions] = NB(TrainingPatterns', TrainingLabels, Testpatterns');
    OutputLabels=FinalPredictions;
    for kk=1:numel(ClassNames) 
        IDX=TestLabels==ClassNames(kk);
        Accuracy(kk)=sum(OutputLabels(IDX)==TestLabels(IDX))*100/sum(IDX);        
    end 
 else % multiclass  
     [FinalPredictions] = NB(TrainingPatterns', TrainingLabels, Testpatterns');
     OutputLabels=FinalPredictions;
     for kk=1:numel(ClassNames) 
         IDX=TestLabels==ClassNames(kk);
         Accuracy(kk)=sum(OutputLabels(IDX)==TestLabels(IDX))*100/sum(IDX);        
     end
end
 