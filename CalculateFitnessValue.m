% This function calculates the fitness value for the given particle

%% Inputs ----------------------
% 1-Vector(SxC): The final models, where S is the swarm size and C is the
% number of classes

%% Outputs ----------------------
% 1-FitnessValue: The calculated fitness value

function FitnessValue=CalculateFitnessValue(Vector)
 FitnessValue=0;
 for k=1:size(Vector,2)
     for kk=k+1:size(Vector,2)
         if k~=kk
             FitnessValue=FitnessValue+ abs(Vector(k)-Vector(kk));
         end
     end
 end