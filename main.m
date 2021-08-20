% This code for implementing the active learning algorithm that was
% published here: Tharwat, A., \& Schenck, W. (2020). Balancing Exploration and Exploitation: A novel active learner for imbalanced data. Knowledge-Based Systems, 210, 106500  

clc
clear all
close all
% RunLHCE(NumRuns,PlotFlag)
% NumRuns :  number of runs
% PlotFlag: 0 -- do not plot the data
%           1 -- plot the data  
RunLHCE(3,0)

load('ResultsLHCE.mat')
%% plot bar chart
figure (1)
subplot(1,3,1)
Temp=cell2mat(NoPointsC(:,1));
XXX=cell2mat(struct2cell( Temp ));
bar(XXX')
ylabel('Number of points')
xlabel('Number of annotated points (first run)')
subplot(1,3,2)
Temp=cell2mat(NoPointsC(:,2));
XXX=cell2mat(struct2cell( Temp ));
bar(XXX');
ylabel('Number of points')
xlabel('Number of annotated points (second run)')
subplot(1,3,3)
Temp=cell2mat(NoPointsC(:,3));
XXX=cell2mat(struct2cell( Temp ));
bar(XXX')
ylabel('Number of points')
xlabel('Number of annotated points (third run)')
sgtitle("The number of points in each class during the annotation process")
 
figure (2)
for k=1:size(ResultsMany,2)
    XXXX{k}=zeros(size(ResultsMany,k), 3);
    for i=1:size(ResultsMany,1)
        LimitedR=cell2mat(ResultsMany(i,k));
        for j=1:size(LimitedR,2)
            XXXX{k}(i,j) =  LimitedR(:,j);
        end
    end
end

subplot(1,3,1)
bar(XXXX{1})
ylabel('Number of points')
xlabel('Number of annotated points (first run)')
subplot(1,3,2)
bar(XXXX{2})
ylabel('Number of points')
xlabel('Number of annotated points (second run)')
subplot(1,3,3)
bar(XXXX{3})
ylabel('Number of points')
xlabel('Number of annotated points (third run)')
sgtitle("The accuracy of each class during the annotation process")
