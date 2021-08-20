% This function for returning selected items in 0/1 logiocal form

function idxFinal= ReturnIndices(idx,N)
%% Inputs -------------------
% 1- idx:  The index of the selected instances
% 2- N:    The total number of instances in the whole data

%% Outputs ------------------
% 1- idxFinal:  The position of the selected instances (0-1 vector), where
% the selected instances are represented with ones, otherwise, zeros
Temp=zeros(1,N);
Temp(idx)=1;
idxFinal=logical((Temp));