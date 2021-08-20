function RunRandom(NumRuns,fun,PlotFlag)
[X,Y,~,~,~,dim,Lb,Ub]=LoadData(fun,PlotFlag);
    
for r=1:NumRuns    
    Budget=ceil(0.05*size(X,1));    
    PerId=randperm(size(X,1));
    Data=X(PerId,:)'; Labels=Y(PerId); 
    PermHistory(r,:)=PerId;
    Du=Data';LabelsDu=Labels;    
    Dl=[]; LabelsDl=[]; 
    Randidx=randperm(size(Du,1));               
    range=Ub-Lb;
    MaxArea=prod(range);
    n1=sum(Y==1);n2=sum(Y==2);
    for i=1:dim
        Lba(i)=min(X(Y==1,i));
        Uba(i)=max(X(Y==1,i));  
        Lbb(i)=min(X(Y==2,i));
        Ubb(i)=max(X(Y==2,i));  
    end    
    AreaA=prod(Uba-Lba);AreaB=prod(Ubb-Lbb);
    for i=1:Budget
        idxFinal= ReturnIndices(Randidx(1:i),size(Du,1)); 
        Dl=Du(idxFinal,:); LabelsDl=LabelsDu(idxFinal);
        Results{i,r}= CalculateSenSpecMulti(Data, Labels, idxFinal,0.5); 
        Results{i,r}.Pos=sum(Labels(idxFinal)==1);
        Results{i,r}.Neg=sum(Labels(idxFinal)==2);
        ResultsMany{i,r}= CalculateSenSpecMultiMany(Data, Labels, idxFinal); 

        if numel(LabelsDl)>1 
            for k=1:dim
                DlLb(k)=min(Dl(:,k));
                DlUb(k)=max(Dl(:,k));  
            end
            if sum(LabelsDl==1)>1
                for k=1:dim                    
                    DlLba(k)=min(Dl(LabelsDl==1,k));
                    DlUba(k)=max(Dl(LabelsDl==1,k));                
                end
            end
            if sum(LabelsDl==2)>1
                for k=1:dim                    
                    DlLbb(k)=min(Dl(LabelsDl==2,k));
                    DlUbb(k)=max(Dl(LabelsDl==2,k));                
                end
            end

            Area=prod(DlUb-DlLb);
            %ResultsRandom{i,r}.CoveredArea=Area/MaxArea;            
            Results{i,r}.CoveredArea=Area;            
            Results{i,r}.TotalDistance=sum(pdist(Dl));
            if sum(LabelsDl==1)>1
                Results{i,r}.TotalDistanceA=sum(pdist(Dl(LabelsDl==1,:)));
                Results{i,r}.TotalAreaA=prod(DlUba-DlLba);
            else
                Results{i,r}.TotalDistanceA=0;
                Results{i,r}.TotalAreaA=0;
            end
            if sum(LabelsDl==2)>1
                Results{i,r}.TotalDistanceB=sum(pdist(Dl(LabelsDl==2,:)));
                Results{i,r}.TotalAreaB=prod(DlUbb-DlLbb);
            else
                Results{i,r}.TotalDistanceB=0;
                Results{i,r}.TotalAreaB=0;
            end                
        else
            Results{i,r}.CoveredArea=0;            
            Results{i,r}.TotalDistance=0;
            Results{i,r}.TotalDistanceA=0;
            Results{i,r}.TotalDistanceB=0;
            Results{i,r}.TotalAreaB=0;
            Results{i,r}.TotalAreaA=0;
        end           
    end
    disp(['Run no. ' num2str(r) ' is finished'])
    clear Randidx idxFinal;
end
clear Data Labels IdxSelected splitAOD Randidx splitLLR LabelsDl Dl
FileName=['ResultsRandom_F' num2str(fun)];
delete ([FileName '.mat'] )
save(FileName, 'Results', 'ResultsMany')
FileName=['Perm_F' num2str(fun)];
delete ([FileName '.mat'] )
save(FileName, 'PermHistory')
