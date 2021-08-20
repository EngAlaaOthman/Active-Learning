% This function is used to find the nearest point to the generated one

%% Inputs -----------------------
% 1-Data (dxN): The original data 
% 2-NewPoint (dx1): The new generated point

%% Outputs ------------------
% 1-NewPointinDataset (dx1):  The nearest point in the dataset
% 2-SelectedidxinDataset:      The index of the selected point in the
% original dataset

function [NewPointinDataset, SelectedidxinDataset]=FindNearestPointinDatasetExclude(Data, NewPoint,idx)
NewData=Data;
NewData(:,idx)=[]; % delete the point from the original data
Distance=pdist([NewPoint';NewData'],'euclidean');
Distance=Distance(1:size(NewData,2));
[~,idmin]=sort(Distance);
NewPointinDataset=NewData(:,idmin(1)); 

% search for the index of the new point in the original Data
Distance=pdist([NewPointinDataset';Data'],'euclidean');
Distance=Distance(1:size(Data,2));
[~,idmin]=sort(Distance);
SelectedidxinDataset=idmin(1); 