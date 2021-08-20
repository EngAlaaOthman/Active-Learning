% This function generates a new point inside the critical region, this is
% by generating a new point randomly and check if this point inside
% the boundaries of the critical region or not.
%% Inputs ----------------------
% 1-FinalModel: The final models
% 2-LBx, UBx:  Decision boundaries of the search space
% 3-dim: The fimension of the search space
% 4-C : The set of classes

%% Outputs ----------------------
% 1-NewPoint: The new generated point

function NewPoint= GeneratePointPSOMultiClass(FinalModel,LBx, UBx, dim,C)

iterations=20;
correction_factor = 1.5;
wMax = 0.9;
wMin = 0.4;
swarm_size = 5*dim;
for i=1:dim
    swarm(:, 1, i)=rand(1,swarm_size)*(UBx(i)-LBx(i))+LBx(i);
end
swarm(:, 4, 1) = inf;          % best value so far
swarm(:, 2, :) = 0;             % initial velocity        

PredictedClasses=zeros(swarm_size,numel(C));

for i = 1 : swarm_size
    Point=[];
    for j=1:dim
        Point=[Point;swarm(i, 1, j)];
    end
    % For evaluation, just classify the pioint with all the current
    % classifiers in the current models, and try to minimize the
    % misclassification rate
    for j=1:size(FinalModel,2)
        Temp = mlp_classify(FinalModel{j},Point');
        PredictedClasses(i,Temp)=PredictedClasses(i,Temp)+1;
        clear idx Temp;
    end
    S(i)=CalculateFitnessValue(PredictedClasses(i,:)) ;
end
[~,idx]=min(S);
% [gbest,idxmin] = min(swarm(:, 4, 1));        % global best position
NewPoint=[];
for k=1:dim
    NewPoint=[NewPoint;swarm(idx, 1, k)];
end
clear S;
for iter = 2 : iterations
    %-- evaluating position & quality ---
    PredictedClasses=zeros(swarm_size,numel(C));
    for i = 1 : swarm_size
        swarm(i, 1, :) = swarm(i, 1, :) + swarm(i, 2, :);     %update x position
        Point=[];
        for j=1:dim 
            Point=[Point;swarm(i, 1, j)];
        end

        for j=1:size(FinalModel,2)
            Temp = mlp_classify(FinalModel{j},Point');              
            PredictedClasses(i,Temp)=PredictedClasses(i,Temp)+1;
            clear idx Temp;
        end
        Fval(i)=CalculateFitnessValue(PredictedClasses(i,:)) ;
        if Fval(i) < swarm(i, 4, 1)                % if new position is better
            swarm(i, 3, :) = swarm(i, 1, :);    % update best x,
            swarm(i, 4, 1) = Fval(i);               % and best value        end            
        end
        [gbest,idxmin] = min(swarm(:, 4, 1)) ;       % global best position
        NewPoint=[];
        for k=1:dim
            NewPoint=[NewPoint;swarm(idxmin, 1, k)];
        end
        w = wMax - iter .* ((wMax - wMin) / iterations);
        %--- updating velocity vectors  
        swarm(i, 2, :) = 0.5*w*swarm(i, 2, :) + correction_factor*rand*(swarm(i, 3, :) - swarm(i, 1, :)) + correction_factor*rand*(swarm(idxmin, 3, :) - swarm(i, 1, :));   %x velocity component                        
        for j=1:dim  
            Flag4up=swarm(i, 1, j)>UBx(j);
            Flag4low=swarm(i, 1, j)<LBx(j);
            swarm(i, 1, j)=(swarm(i, 1, j).*(~(Flag4up+Flag4low)))+UBx(j).*Flag4up+LBx(j).*Flag4low;
        end
    end
end
