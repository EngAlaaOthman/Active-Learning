function C = mlp_train(data, labels, M, MaxEpochs)
% --- train an MLP with M hidden nodes
% --- data=mxn, m -> number of instances and n -> is the number of features
% --- labels=mx1
%
%* initialization
[n,m] = size(data); c = max(labels); % number of classes
% form c-component binary (target) vectors from the labels
bin_labZ = repmat(labels,1,c) == repmat(1:c,n,1);
% weights and biases input-hidden:
W1 = randn(M,m); B1 = randn(M,1);
% weights and biases hidden-output
W2 = randn(c,M); B2 = randn(c,1);
E = inf; % criterion value
t = 1; % epoch counter
eta = 0.1; % learning rate
epsilon = 0.0001; % termination criterion
%
%* normalization
mZ = mean(data); sZ = std(data);
data = (data - repmat(mZ,n,1))./repmat(sZ,n,1);
% store for the normalization of the testing data
C.means = mZ; C.std = sZ;
%
%* calculation
while E > epsilon && t <= MaxEpochs
    % outputs of the hidden layer
    oh = 1./(1 + exp(-[W1 B1] * [data ones(n,1)]'));
    % outputs of the output layer
    o = 1./(1+exp(-[W2 B2]*[oh; ones(1,n)]));
    E = sum(sum((o'-bin_labZ).^2));
    t = t + 1; % increment epoch counter
    del_o = (o-bin_labZ').*o.*(1-o);
    del_h = ((del_o'*W2).*oh'.*(1-oh'))';
    for i = 1:c % update W2 and B2
        for j = 1:M
            W2(i,j) = W2(i,j)-eta*del_o(i,:)*oh(j,:)';
        end
        B2(i) = B2(i)-eta*del_o(i,:)*ones(n,1);
    end
    for i = 1:M % update W1 and B1
        for j = 1:m
            W1(i,j) = W1(i,j)-eta*del_h(i,:)*data(:,j);
        end
        B1(i) = B1(i)-eta*del_h(i,:)*ones(n,1);
    end
end
%
%* store the output
C.W1 = W1; % weights input-hidden
C.W2 = W2; % weights hidden-output
C.B1 = B1; % bias input-hidden
C.B2 = B2; % bias hidden-output
C.oh = oh; % output of the hidden layer
%---------------------------------------------------------%

