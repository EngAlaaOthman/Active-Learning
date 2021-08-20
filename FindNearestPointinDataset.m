% This function is used to find the nearest point to the generated one

%% Inputs -----------------------
% 1-Data (dxN): The original data 
% 2-NewPoint (dx1): The new generated point

%% Outputs ------------------
% 1-NewPointinDataset: The nearest point in the dataset
% 2-SelectedidxinDataset: The index of the selected point in the dataset

function [NewPointinDataset, SelectedidxinDataset]=FindNearestPointinDataset(Data, NewPoint)
Distance=pdist([NewPoint';Data'],'euclidean');
Distance=Distance(1:size(Data,2));
[~,idmin]=sort(Distance);
clear Distance 
NewPointinDataset=Data(:,idmin(1)); 
SelectedidxinDataset=idmin(1); 
clear idmin i