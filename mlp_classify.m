%------------------------------------------------------------%
function labels = mlp_classify(C,test_data)
% classify test_data using the MLP classifier C
AvailableLabels = 1:size(C.W2,1);
%* normalization
n = size(test_data,1);
test_data = (test_data - repmat(C.means,n,1))./repmat(C.std,n,1);
oh = 1./(1+exp(-[C.W1 C.B1]*[test_data ones(n,1)]'));
%* outputs of the hidden layer
o = 1./(1+exp(-[C.W2 C.B2]*[oh; ones(1,n)]));
%* outputs of the output layer
[~ ,Index] = max(o);
labels = AvailableLabels(Index);
labels = labels(:);
%------------------------------------------------------------%