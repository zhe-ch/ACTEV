%=====================================================
% FileName: extract_online_tiletraces.m
% Designby: Zhe
% Modified: 07/08/2021
% Describe: Extract fluorescence traces from the calcium image dataset.
%           Suppose C: Number of tiles; T: Number of frames
%           traces  <C,T>
%========================================================================

clear variables;

file_path = '../CaimanData/Hipp6_linear4';
name = strcat(file_path, '/Hipp6_linear4_win_mc.tif');
tiffInfo = imfinfo(name);
T = numel(tiffInfo);
imageData = single(imread(name, 'Index', 1));
[d1,d2] = size(imageData);

% SE (structrual element) for morphology operations on the cell binary template
H1 = ones(19);

num_cell = 1024;
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
    
    for j = 1:32
        for i = 1:32
            % fluorescence = sum(enhance_img((j-1)*16+1:j*16, (i-1)*16+1:i*16), 'all');
            fluorescence = max(enhance_img((j-1)*16+1:j*16, (i-1)*16+1:i*16), [], 'all');
            traces((j-1)*32+i, t) = fluorescence;
        end
    end
    
    progress = 100 * (t / T);
    % Deleting 4 characters (The three digits and the % symbol)
	fprintf('\b\b\b\b%3.0f%%', progress); 
    pause(0.1);
end
fprintf('\n');

% Save traces.
name = strcat(file_path, '/Hipp6_linear4_online_tiletraces.mat');
save(name, 'traces');

