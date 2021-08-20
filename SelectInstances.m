% This function is used to generate points using our proposed algorithm
% (examploration and exploitation phases): exploration phase has four
% variants (BE, LHCEI, LHCEII, LHCEIII)

%% Inputs -----------------------
% 1-FinalModel: The set of trained models (hypotheses) during the last iterations
% 2-Data (dxN): The original data 
% 3-SelectedPoints: The selected data from the whole data
% 4-TargetsSelectedPoints: The class labels of the selected instances
% 5-LBx1, LBx2, UBx1, UBx2: boundaries of the space
% 6-a: Exploration-exploitation parameter
% 7-dim: The dimension of the problem
% 8-Nc: The number of weak learners (single simple classifiers) [Here we used linear perceptrons]

%% Outputs ------------------
% 1-SelectedidxData:  The index of the selected instance
% 2-FinalModel2:      The final model after adding the last set of hypotheses  

% This version is designed to generate one sample in each iteration. In
% other words, the main function calls this function iteratively for
% generating only one sample

function [SelectedidxData,FinalModel2]=SelectInstances(FinalModel,Data, Labels,SelectedPoints, TargetsSelectedPoints, Lb, Ub,a, dim, Nc)

Exploitationphase=1; % -- This flag to know if we have samples from each class to be able to run a classifier, then use the exploitation phase (1 means we can use the exploitation phase)
% -- Check if we have samples in both classes, so, we can use the exploration
% -- and exploitation phases according to the parameter a
C=unique(TargetsSelectedPoints);
if numel(C)<numel(unique(Labels)) % There are no instances from all classes
    Exploitationphase=0;
end
FinalModel2={};
        
%% Start generating points
if rand(1)>a && Exploitationphase==1  % Do exploitation (ExploitationPhase)        
    TargetsSelectedPoints=TargetsSelectedPoints(:);
    [Model,~]=GenerateMLPClassifiers([SelectedPoints;ones(1,size(SelectedPoints,2))], TargetsSelectedPoints', Nc, dim); 
    %-- This step keeps the weights of the ideal classifiers that classify
    %-- the data perfectly
    if size(Model,2)>0
        PrePruningModels=PrePruning(Model, [SelectedPoints;ones(1,size(SelectedPoints,2))], TargetsSelectedPoints,ceil(Nc/2),dim);
        c1=size(FinalModel,2);c2=size(PrePruningModels,2);
        FinalModel(c1+1:c1+c2)=PrePruningModels;
    else        
    end
    %-- Add the selected weights to the final weights
%     c1=size(FinalModel,2);c2=size(PrePruningModels,2);
%     FinalModel(c1+1:c1+c2)=PrePruningModels;
    
    %-- Keep the classifiers that classify all training samples perfectly
    %(keep all models/hypotheses that obtain more than the average accuracy/GM of all models)
    if size(FinalModel,2)>0
        PostPruningModel=PostPruning(FinalModel, [SelectedPoints;ones(1,size(SelectedPoints,2))], TargetsSelectedPoints,dim);
        [NewGeneratedPoint]= GeneratePointPSOMultiClass(PostPruningModel,Lb, Ub, dim,C);
    else % generate point randomly
        idxs=randperm(numel(Labels));
        NewGeneratedPoint=Data(:,idxs(1));
    end
    % Calculate the class for the nearest point to the new point
    [NewPointData,SelectedidxData]=FindNearestPointinDataset(Data, NewGeneratedPoint(1:dim));
    
    % Check if the selected point is already in the selected points
    RepeatedPoint=CheckRepeatedPoints(SelectedPoints, NewPointData, dim);
    
    % search if the new point is already exists (to avoid selecting duplicate points)
    SelectedidxDataList=SelectedidxData;
    while RepeatedPoint==1 % this point is already found
        [NewPointData, NewSelectedidxData]=FindNearestPointinDatasetExclude(Data, NewGeneratedPoint(1:dim),SelectedidxDataList);
        RepeatedPoint=CheckRepeatedPoints(SelectedPoints, NewPointData, dim);
        if RepeatedPoint==1
            SelectedidxDataList=[SelectedidxDataList;NewSelectedidxData];        
        else
            SelectedidxData=NewSelectedidxData;
        end
    end
else % -------------Exploration phase 
    % Generate a point using the LHCE-III model             
    NewGeneratedPoint= LHCEIII(Data, SelectedPoints, Lb,Ub,dim);           
    
    % Calculate the class for the nearest point to the new point
    [NewPointData,SelectedidxData]=FindNearestPointinDataset(Data, NewGeneratedPoint(1:dim));
    
    % Check if the selected point is already in the selected points
    RepeatedPoint=CheckRepeatedPoints(SelectedPoints, NewPointData, dim);
    
    % search if the new point is already exists (to avoid selecting duplicate points)
    SelectedidxDataList=SelectedidxData;
    while RepeatedPoint==1 % this point is already found
        [NewPointData, NewSelectedidxData]=FindNearestPointinDatasetExclude(Data, NewGeneratedPoint(1:dim),SelectedidxDataList);
        RepeatedPoint=CheckRepeatedPoints(SelectedPoints, NewPointData, dim);
        if RepeatedPoint==1
            SelectedidxDataList=[SelectedidxDataList;NewSelectedidxData];        
        else
            SelectedidxData=NewSelectedidxData;
        end
    end
end