%=========================================================
% FileName: linear_classifier_train.m
% Designby: Zhe
% Modified: 09/02/2021
% Describe: Training linear classifier for the position decoding 
%           from FPGA recorded traces.
%=========================================================================

clear variables;

% Configure parameters.
CELL_NUM = 1024;  % Capacity of cells for decoding.

% Configure PATH for FPGA recorded traces.
file_path = "D:\RTCImgProc_pc-Large-FF\RTCImgProc\file\trace\";
name = strcat(file_path, "trace.txt");

% Read in FPGA recorded traces.
trace_table = readtable(name);
trace = table2array(trace_table);
training_data = trace;

% Load target labels (temporary).
load("target_labels.mat");

% Linear classifier training.
Mdl = fitcecoc(training_data,target_labels,'Coding','ordinal','Learners','linear');

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

% Save parameters of the linear classifier to txt file: lc_paramater.txt
wrtFileName = "lc_parameters.txt";
fileID = fopen(wrtFileName,'w');
for i = 1:Cell_N
    fprintf(fileID, '%f\n', Beta(i,:));
end
fprintf(fileID, '%f\n', Bias);
fclose(fileID);

save('training_result.mat', 'Mdl', 'training_data');

% Save parameters of the linear classifier to bin file: param.bin
wrtFilePath = "D:\RTCImgProc_pc-Large-FF\RTCImgProc\file\param\";
wrtFileName = "param.bin";
name = strcat(wrtFilePath, wrtFileName);
fileID = fopen(name,'w');

for c = 1:Cell_N
    for i = 1:Learner_N
        fwrite(fileID, Beta(c,i), 'float');
    end
end

for c = Cell_N-1:CELL_NUM
    for i = 1:Learner_N
        fwrite(fileID, Beta(c,i), 'float');
    end
end

for i = 1:Learner_N
    fwrite(fileID, Bias(i), 'float');
end

fclose(fileID);
