% This function keeps/preserves the classifiers that classify the current data correctly
%% Inputs ----------------------
% 1-Model (1xm): The generated models
% 2-data:    The current data (each sample is a column)
% 3-Targets: The targets/class labels of the samples in data   
% 4-NumSelected: Number of selected classifiers
% 5- dim: The dimension of the data

%% Outputs ----------------------
% 1-SelectedModel (1xNs): The selected models

function SelectedModel=PrePruning(Model, data, Targets,NumSelected,dim)
SelectedModel=[];
C=unique(Targets);
for i=1:numel(C)
    NoClass(i)=sum(Targets==C(i));
end
counter=1;
for i=1:numel(C)
    for j=i+1:numel(C)
        IR(counter)=NoClass(i)/NoClass(j);
        counter=counter+1;
    end
end
MinIR =min(IR); % imbalance ratio
for i=1:size(Model,2) % For each classifier
    % If the dichotomy classifies the data correctly add it to the
    % weights array
    if size(Model{i}.W2,1)>1
        Predictions = mlp_classify(Model{i},data(1:dim,:)');
        Results= CalculateClassificationScores(Targets, Predictions,C);       
        Acc(i)=Results.Acc; 
        GM(i)=Results.GM;
    end
end

if MinIR>numel(C) || MinIR<(1/numel(C))    
    [SortedGM,idx]=sort(GM,'descend');    
    for i=1:size(idx,2)
       NewModel{i}= Model{idx(i)};
    end
    Temp=sum(isnan(SortedGM));
    NewModel(1:Temp)=[] ;  
    SortedGM(:,1:Temp)=[];
    clear Temp idx;
    counter=1;
    for i=1:min(NumSelected,size(SortedGM,2))
        if SortedGM(i)>0.5
            SelectedModel{counter}=NewModel{i}; 
            counter=counter+1;
        end                    
    end
else
    [SortedAcc,idx]=sort(Acc,'descend');
    for i=1:size(idx,2)
        NewModel{i}= Model{idx(i)};
    end
    counter=1;
    for i=1:NumSelected
        if SortedAcc(i)>0.5
            SelectedModel{counter}=NewModel{i}; 
            counter=counter+1;
        end                    
    end  
end

if size(SelectedModel,2)==0
    [SortedAcc,idx]=sort(Acc,'descend');
    for i=1:size(idx,2)
        NewModel{i}= Model{idx(i)};
    end
    counter=1;
    for i=1:NumSelected
        if SortedAcc(i)>0.5
            SelectedModel{counter}=NewModel{i}; 
            counter=counter+1;
        end                    
    end  
end