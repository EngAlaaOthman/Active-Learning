% This function is used to check if the nearest point is already in the
% selected labeled set

%% Inputs -----------------------
% 1-SelectedPoints (dx nl): The selected instances, nl: number of labeled
% points
% 2-NewPointData (dx1): The new generated point
% 3-dim: The dimension of the search space        

%% Outputs ------------------
% 1-RepeatedPoint:  Returns: one if the point is found, or zero if the point is not found

function RepeatedPoint=CheckRepeatedPoints(SelectedPoints, NewPointData, dim)

idx= SelectedPoints==NewPointData;
idx2=sum(idx,1)==dim;
RepeatedPoint=0;
if sum(idx2)>0 % repeated points
   RepeatedPoint=1;
end
clear idx idx2 