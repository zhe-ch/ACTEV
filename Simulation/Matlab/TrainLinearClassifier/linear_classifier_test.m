%=========================================================
% FileName: linear_classifier_test.m
% Designby: Zhe
% Modified: 09/02/2021
% Describe: Testing linear classifier for the position decoding 
%           from FPGA recorded traces.
%=========================================================================

clear variables;

load('training_result.mat');

% Linear classifier test.
[predicted_output, negloss, PBScore] = predict(Mdl,training_data);

% Extract linear clasifier model parameters.
Cell_N = size(training_data, 2);
Learner_N = size(Mdl.BinaryLearners, 1);
Class_N = size(Mdl.ClassNames, 1);

Beta = zeros(Cell_N, Learner_N);
Bias = zeros(Learner_N, 1);
for i = 1:Learner_N
    Beta(:,i) = Mdl.BinaryLearners{i}.Beta;
    Bias(i) = Mdl.BinaryLearners{i}.Bias;
end
CodingMatrix = Mdl.CodingMatrix;

test_input = training_data';
T = size(test_input, 2);

% Compute score of input based on the linear classification model.
score = zeros(Learner_N, T);
for t = 1:T
    for i = 1:Learner_N
        score(i,t) = dot(test_input(:,t), Beta(:,i)) + Bias(i);
    end
end

% Compute loss of the input for each class.
loss = zeros(Class_N, T);
for t = 1:T
    for i = 1:Class_N
        loss(i,t) = sum(max(0, 1 - score(:,t) .* CodingMatrix(i,:)'));
    end
end

% Compute predicted labels.
test_output = zeros(T,1);
for t = 1:T
    test_output(t) = find(loss(:,t) == min(loss(:,t)));
end




