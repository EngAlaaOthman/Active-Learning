% This function to run the LHCE algorithm
% NumRuns : number of runs
% PlotFlag : 1-> plot the results, 0-> do not plot the results

function RunLHCE(NumRuns, PlotFlag)
% Load the data
[X,Y,~,~,N,dim,Lb,Ub]=LoadData(PlotFlag);
for r=1:NumRuns
    Budget=ceil(0.05*size(X,1)); % we used budget of 5% from the whole data   
    % shuffel the data in each run
    PerId=randperm(size(X,1));
    Data=X(PerId,:)'; Labels=Y(PerId);      
    Counter=1; 
    Nc=100; % number of weak learners
    WeightValue=1;           
    SampleidxLHCEIII=[];FinalModelLHCEIII={};
    for i=1:Budget      %5:5:50 
        if i==1
            idxs=randperm(N); %FirstPoint=Data(:,idxs(1));            
            SampleidxLHCEIII(numel(SampleidxLHCEIII)+1)=idxs(1);
            clear idxs; 
        else
            a=(1-(numel(SampleidxLHCEIII)/(Budget))); % reduce the value of a to switch from the exloration phase to the exploitation phase
            [SampleidxLHCEIII(i),NewModel]=SelectInstances(FinalModelLHCEIII, Data, Labels, Data(:,SampleidxLHCEIII), Labels(SampleidxLHCEIII), Lb, Ub, a, dim, Nc);            
            c2=size(NewModel,2);
            if c2>0
                FinalModelLHCEIII=NewModel;
            end
        end
        idxFinal= ReturnIndices(SampleidxLHCEIII,N);
        % find the number of labeled points in each class
        NoPointsC{i,r}.C1=sum(Labels(idxFinal)==1);
        NoPointsC{i,r}.C2=sum(Labels(idxFinal)==2);
        NoPointsC{i,r}.C3=sum(Labels(idxFinal)==3);
        % calculate the classification results
        ResultsMany{i,r}= CalculateSenSpecMultiMany(Data, Labels, idxFinal); 
        
        % add the new labeled point to the labaled data
        LabelsDl=Labels(idxFinal);
        Dl=Data(:,idxFinal);
        Dl=Dl';
    
        disp(['--Run no. ' num2str(r) ' Point' num2str(numel(LabelsDl))])
    end   
    disp(['Run no. ' num2str(r) ' is finished'])
    clear Randidx idxFinal;    
end
clear Data Labels IdxSelected  Randidx  LabelsDl Dl
FileName='ResultsLHCE.mat';
delete ([FileName '.mat'] );
save(FileName, 'NoPointsC', 'ResultsMany')

