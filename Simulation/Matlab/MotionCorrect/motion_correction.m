%=====================================================
% FileName: motion_correction_1000.m
% Designer: Zhe
% Modified: 05/29/2021
% Describe: Extract 1000 frames of image from TIFF and store in image.bin
%           Perform matlab simulation of motion correction for 1000 frames.
%==========================================================================

clear variables;

%% User Parameters
inputType = 'bin';    % 'tiff' or 'bin'
inputPath = './image/';
FileName = 'msImage.bin';
inputFile = strcat(inputPath, FileName);

% For binary files
imgWidth = 512;
imgHeight = 512;
numFrames = 1000;
dataType = 'uint8';

%% User Options
cfg.writeBin = false; % true or false
cfg.outputFile = 'msImage.bin';
cfg.plot = false;

%% Read Image Data
switch lower(inputType)
    case 'tiff'
        imgData = readTiff(inputFile);
    case 'bin'
        imgData = readBin(inputFile, imgWidth, imgHeight, numFrames, dataType);
    case 'bin-s'
        imgData = zeros(imgHeight, imgWidth, numFrames, dataType);
        for i = 1:numFrames
            FileName = strcat('image_f',sprintf('%03d',i-1),'.bin');
            inputFile = strcat(inputPath, FileName);
            imgData(:,:,i) = readBin(inputFile, imgWidth, imgHeight, 1, dataType);
        end
        fprintf('\n');
    otherwise
        error('Unknown Input Type.');
end

%% Optional Write to Binary
if cfg.writeBin
    fid = fopen(cfg.outputFile, 'wb');
    imgData = permute(imgData, [2 1 3]);
    fwrite(fid, imgData, 'uint8');
    fclose(fid);
end

%% Motion Correction Algorithm

imgHeight = 512;
imgWidth = 512;

% Contrast Filter
gSig = 7;
gSiz = 17;
psf = my_fspecial_gaussian(round(gSiz), gSig);
ind_nonzero = (psf(:) >= max(psf(:,1)));
psf = psf - mean(psf(ind_nonzero));
psf(~ind_nonzero) = 0;
cell_bin = (psf ~= 0);
psf_scale = round(psf * 90000);

% Select ROI for motion correction
% Option-1: 128-point FFT
roi_row_start = 192;
roi_col_start = 192;
fft_size = 128;

% Option-2: 64-point FFT
%roi_row_start = 224;
%roi_col_start = 224;
%fft_size = 64;

% Option-3: 32-point FFT
%roi_row_start = 240;
%roi_col_start = 240;
%fft_size = 32;

% Get template for motion correction
Yf = single(imgData);

% Extract region rich in features for alignment
Y_roi = Yf(roi_row_start-8:(roi_row_start+fft_size-1+8),roi_col_start-8:(roi_col_start+fft_size-1+8),:);

perm = 1:33:990;
Y_tml = Y_roi(:,:,perm); 
template = floor(mean(Y_tml,3));
template_f = my_imfilter(template, psf_scale);
template_f = template_f(9:9+fft_size-1,9:9+fft_size-1);

cnt_frame = 0;
drift_x = 0;
drift_y = 0;

% Perform motion correction for image stack
% Contrast filtering
Y_f = zeros (imgHeight, imgWidth, numFrames, 'single');
for t = 1:numFrames
    Y_f(:,:,t) = my_imfilter(Yf(:,:,t), psf_scale);
end

adj_shifts_r = zeros(numFrames,2);

% Set parameters for rigid motion correction
options_r = NoRMCorreSetParms('d1',fft_size,'d2',fft_size,'bin_width',50,'max_shift',32,...
    'iter',1,'correct_bidir',false, 'us_fac', 1, 'upd_template', false);

for rnd = 1:5
    roi_adj_row_start = roi_row_start - drift_y;
    roi_adj_col_start = roi_col_start - drift_x;
    Y_t = Y_f(roi_adj_row_start:(roi_adj_row_start+fft_size-1),roi_adj_col_start:(roi_adj_col_start+fft_size-1),(rnd-1)*200+1:rnd*200);
    shifts1 = rigid_mcorre(Y_t,options_r,template_f);
    shifts_r = squeeze(cat(3,shifts1(:).shifts));
    adj_shifts_r((rnd-1)*200+1:rnd*200,:) = shifts_r + [drift_y,drift_x];
    avr_shifts_r = mean(shifts_r);
    if (avr_shifts_r(1) > 1)
        drift_y = drift_y + floor(avr_shifts_r(1));
    elseif (avr_shifts_r(1) < -1)
        drift_y = drift_y + ceil(avr_shifts_r(1));
    end
    if (avr_shifts_r(2) > 1)
        drift_x = drift_x + floor(avr_shifts_r(2));
    elseif (avr_shifts_r(2) < -1)
        drift_x = drift_x + ceil(avr_shifts_r(2));
    end
end

mot_vector_daq = adj_shifts_r;

fprintf('[Info] Finish motion vector extraction for segment.\n');

% Perform motion correction
Yf_mc = Yf;
for i = 1:numFrames
    for x = 1:imgWidth
        for y = 1:imgHeight
            if (((y-adj_shifts_r(i,1))>0) && ((y-adj_shifts_r(i,1))<=imgHeight) && ((x-adj_shifts_r(i,2))>0) && ((x-adj_shifts_r(i,2))<=imgWidth))
                Yf_mc(y,x,i) = Yf(y-adj_shifts_r(i,1),x-adj_shifts_r(i,2),i);
            end
        end
    end
end

%% Plot Results

if cfg.plot
    figure('Position', [100 100 800 500]);
    plot(mot_vector_daq);
    lgd = legend('motion vector y', 'motion vector x');
    lgd.EdgeColor = 'w';    % White border
    lgd.FontSize = 12;      % Font size
end