% This function generates a new sample using the LHCEIII algorithm. 
%% Inputs ------------------------
% 1-Data (d,N): The patterns of the original data, N : the number of points
% 2-data (d,nl): The selected instances (nl: number of selected instances)
% 3-LBx,UBx (1xd): Boundaries of the search space
% 4-dim : Dimensions of the space

%% Outputs ----------------------
% 1-NewPoint ((d+1)x1): The new generated point

function [NewPoint]= LHCEIII(Data,data, Lb, Ub ,dim)
eps=1e-8;
n=size(data,2); % number of points
% NDivisons: the number of divisions in each dimension
% increasing the number of divisions increases the required computational efforts
NDivisons=round(n/2)+1; 

% Divide each dimension in the space into NDivisions
for i=1:dim
    D(i)=Ub(i)-Lb(i); % The range of the i-th dimension
end

Q=NDivisons^dim; % Total number of quarters/cells

elements={};
List=0:NDivisons-1;
for i=1:dim     
     elements{i}=List;
end
combinations = cell(1, numel(elements)); %set up the varargout result
[combinations{:}] = ndgrid(elements{:});
combinations = cellfun(@(x) x(:), combinations,'uniformoutput',false); %there may be a better way to do this
Temp = [combinations{:}]; % NumberOfCombinations by N matrix. 
clear combinations elements List

for q=1:Q % for each division
    for d=1:dim
        Quad(q).LBx(d)=Lb(d)+ Temp(q,d)*double(D(d)/NDivisons);
        Quad(q).UBx(d)=Quad(q).LBx(d)+ D(d)/NDivisons  ;  
        Quad(q).NoUnlabelledSamples=0;
        Quad(q).NoLabelledSamples=0;
        Quad(q).Ratio=0;
        Quad(q).Selected=false;
        Quad(q).Rejected=false;
    end
end

% Search how many unlabelled samples in each division
for i=1:size(Data,2) % For each sample in the data
    for q=1:Q % For each cell
        for d=1:dim                       
            if ismembertol(Quad(q).LBx(d), Lb(d), eps)
                Cond(d)=(Data(d,i)>Quad(q).LBx(d) || ismembertol(Quad(q).LBx(d), Data(d,i), eps)) && (Data(d,i)<Quad(q).UBx(d) || ismembertol(Quad(q).UBx(d), Data(d,i), eps));                                 
            else                
                Cond(d)=Data(d,i)>Quad(q).LBx(d) && (Data(d,i)<Quad(q).UBx(d) || ismembertol(Quad(q).UBx(d), Data(d,i), eps));
            end
        end
        if(all(Cond))
            Quad(q).NoUnlabelledSamples=Quad(q).NoUnlabelledSamples+1;
        end
    end
end

for i=1:size(data,2) % For each sample in the data
    for q=1:Q % For each cell
        for d=1:dim
            if ismembertol(Quad(q).LBx(d), Lb(d), eps)
                Cond(d)=(data(d,i)>Quad(q).LBx(d) || ismembertol(Quad(q).LBx(d), data(d,i), eps)) && (data(d,i)<Quad(q).UBx(d) || ismembertol(Quad(q).UBx(d), data(d,i), eps));                                 
            else                
                Cond(d)=data(d,i)>Quad(q).LBx(d) && (data(d,i)<Quad(q).UBx(d) || ismembertol(Quad(q).UBx(d), data(d,i), eps));
            end
        end
        if(all(Cond))
            Quad(q).NoLabelledSamples=Quad(q).NoLabelledSamples+1;
         end
    end
end

% find the most uncertain cell
MaxRatio=0; SelectedDivision=0;
for q=1:Q % For each cell    
    Quad(q).Ratio=Quad(q).NoUnlabelledSamples/(Quad(q).NoLabelledSamples+1);
    if Quad(q).Ratio>=MaxRatio
        MaxRatio=Quad(q).Ratio;
        SelectedDivision=q;
    end
end

% Generate a new point in the selected quadrant/cell
NewPoint=[];
for i=1:dim
    Temp=Quad(SelectedDivision).LBx(i);
    Temp2=rand(1,1)*(Quad(SelectedDivision).UBx(i)-Quad(SelectedDivision).LBx(i));
    NewPoint(i,1)=Temp+Temp2;           
end
%NewPoint=[NewPoint];
