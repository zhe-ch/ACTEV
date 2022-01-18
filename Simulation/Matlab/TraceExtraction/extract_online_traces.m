%=====================================================
% FileName: extract_online_traces.m
% Designby: Zhe
% Modified: 03/09/2021
% Describe: Extract fluorescence traces from the calcium image dataset.
%           Suppose C: Number of cells; T: Number of frames
%           traces  <C,T>
%========================================================================

clear variables;

file_path = '/media/blairlab/Seagate Expansion Drive/RealTimeFiles';
name = strcat(file_path, '/Caiman-Online/Hipp6_linear4/Hipp6_linear4_contours.mat');
load(name);

name = strcat(file_path, '/win_mc/Hipp6_linear4_win_mc.tif');
tiffInfo = imfinfo(name);
T = numel(tiffInfo);
imageData = single(imread(name, 'Index', 1));
[d1,d2] = size(imageData);

% SE (structrual element) for morphology operations on the cell binary tempalte
H1 = ones(19);

num_cell = length(cellCenter);
traces = zeros(num_cell, T);

progress = 0;
fprintf('Computation Progress: %3d%%\n', progress);

for t = 1:T
    
    Yf = single(imread(name, 'Index', t));
    % Step 1: Enhancement
    % Remove salt (white spot) noise
    Yf_denoise = conv2(Yf, ones(3)/9, 'same');
    
    % Background subtraction based on morphological opening
    enhance_img = Yf_denoise - imopen(Yf_denoise, H1);
    
    for c = 1:num_cell
        center_y = cellCenter(c,1);
        center_x = cellCenter(c,2);
        fluorescence = 0;
        for j = center_y-12:center_y+12
            for i = center_x-12:center_x+12
                if ((j>0)&&(j<=d1)&&(i>0)&&(i<=d2))
                    if (cellMask(c,j-center_y+13,i-center_x+13) == 1)
                        fluorescence = fluorescence + enhance_img(j,i);
                    end
                end
            end
        end
        traces(c, t) = fluorescence;
    end
    
    progress = 100 * (t / T);
    % Deleting 4 characters (The three digits and the % symbol)
	fprintf('\b\b\b\b%3.0f%%', progress); 
    pause(0.1);
end
fprintf('\n');

% Save traces.
name = strcat(file_path, '/Caiman-Online/Hipp6_linear4/Hipp6_linear4_online_traces.mat');
save(name, 'traces');

