% This function keeps/preserves only the classifiers that classify the current data correctly
%% Inputs----------------------------
% 1-FinalModel: The final hypotheses after deleting all redundant and
% classifiers with small classification accuracy
% 2-data:    The current data (each sample is a column)
% 3-Targets: The targets/class labels of the samples in data   
% 4-dim: The dimensions of the search space

%% Outputs----------------------------
% 1-NewModel: The model after removing redundant and the worst classifiers

function NewModel=PostPruning(FinalModel, data, Targets,dim)
NewModel={};
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

for i=1:size(FinalModel,2) % For each classifier
    if size(FinalModel{i}.W2,1)>1
        % If the dichotomy classifies the data correctly add it to the
        % weights array
        Predictions = mlp_classify(FinalModel{i},data(1:dim,:)');
        Results= CalculateClassificationScores(Targets, Predictions,C);       
        Acc(i)=Results.Acc;
        GM(i)=Results.GM;
    end
end
UseAcc=0;    
if MinIR>numel(C) || MinIR<(1/numel(C)) % imbalanced data
    [SortedGM,idx]=sort(GM,'descend');
    % To avoid selecting NaN GM    
    for i=1:size(idx,2)
       FinalModel2{i}= FinalModel{idx(i)};
    end
    Temp=sum(isnan(SortedGM));
    FinalModel2(1:Temp)=[] ;  
    SortedGM(:,1:Temp)=[]; 
    idx(1:Temp)=[];
    if sum(SortedGM)==0
       UseAcc=1; 
    end
    if size(unique(SortedGM),2)>1 % not identical 
        MeanAcc=mean(SortedGM);
        counter=1;
        for i=1:size(FinalModel2,2)
             if SortedGM(i)>MeanAcc
                NewModel{counter}=FinalModel2{i}; 
                counter=counter+1;
            end
        end
    else
         NewModel=FinalModel2(1:ceil(0.5*size(FinalModel2,2)));
    end
else
    [SortedAcc,idx]=sort(Acc,'descend');
    for i=1:size(idx,2)
       FinalModel2{i}= FinalModel{idx(i)};
    end
    if size(unique(SortedAcc),2)>1 % not identical 
        MeanAcc=mean(SortedAcc);
        counter=1;
        for i=1:size(FinalModel2,2)
            if SortedAcc(i)>MeanAcc
                NewModel{counter}=FinalModel2{i}; 
                counter=counter+1;
            end
        end
    else
         NewModel=FinalModel2(:,1:ceil(0.5*size(FinalModel2,2)));
    end
end
if UseAcc==1  % use accuracy instead of GM
    NewModel={};
    [SortedAcc,idx]=sort(Acc,'descend'); 
    for i=1:size(idx,2)
        FinalModel2{i}= FinalModel{idx(i)};
    end
    SortedAcc=SortedAcc(1:sum(SortedAcc>0));    
    idx=idx(1:sum(SortedAcc>0));        
    FinalModel2(1:sum(SortedAcc>0))=[];  
    if size(unique(SortedAcc),2)>1 % not identical 
        MeanAcc=mean(SortedAcc);
        counter=1;
        for i=1:size(FinalModel2,2)
            if SortedAcc(i)>MeanAcc
                NewModel{counter}=FinalModel2{i}; 
                counter=counter+1;
            end
        end
    else
         NewModel=FinalModel2(:,1:ceil(0.5*size(FinalModel2,2)));
    end
end