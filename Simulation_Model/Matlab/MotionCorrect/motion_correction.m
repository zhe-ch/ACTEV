%=====================================================
% FileName: motion_correction_1000.m
% Designby: Zhe
% Modified: 05/29/2021
% Describe: Extract 1000 frames of image from TIFF and store in image.bin
%           Perform matlab simulation of motion correction for 1000 frames.
%==========================================================================

clear variables;

file_path = "xx/";
file_name = "xxx.tif";
name = strcat(file_path, file_name);

tiffInfo = imfinfo(name);
Total_T = numel(tiffInfo);
TIFF_CNT = floor(Total_T / 1000);

d1 = 512;
d2 = 512;

% Contrast Filter
gSig = 7;
gSiz = 17;
psf = fspecial('gaussian', round(gSiz), gSig);
ind_nonzero = (psf(:) >= max(psf(:,1)));
psf = psf - mean(psf(ind_nonzero));
psf(~ind_nonzero) = 0;
cell_bin = (psf ~= 0);
psf_scale = round(psf * 90000);

% Select ROI for motion correction
roi_row_start = 192;
roi_col_start = 192;

% Get template for motion correction
Yf = zeros(d1, d2, 1000);
for t = 1:1000
    Yf(:,:,t) = imread(name, 'Index', t);
end
Yf = single(Yf);

% Extract region rich in features for alignment
Y_roi = Yf(roi_row_start-8:(roi_row_start+127+8),roi_col_start-8:(roi_col_start+127+8),:);

perm = 1:33:990;
Y_tml = Y_roi(:,:,perm); 
template = floor(mean(Y_tml,3));
template_f = imfilter(template, psf_scale, 'same');
template_f = template_f(9:9+127,9:9+127);

cnt_frame = 0;
drift_x = 0;
drift_y = 0;

% Perform motion correction for TIFF stack
T = 1000;

% Load images from TIFF stack
Yf = zeros(d1, d2, T);
for t = 1:T
    Yf(:,:,t) = imread(name, 'Index', t);
end
Yf = single(Yf);

% Contrast filtering
Y_f = imfilter(Yf, psf_scale, 'same');

adj_shifts_r = zeros(T,2);

% Set parameters for rigid motion correction
options_r = NoRMCorreSetParms('d1',128,'d2',128,'bin_width',50,'max_shift',16,...
    'iter',1,'correct_bidir',false, 'us_fac', 1, 'upd_template', false);

for rnd = 1:5
    roi_adj_row_start = roi_row_start - drift_y;
    roi_adj_col_start = roi_col_start - drift_x;
    Y_t = Y_f(roi_adj_row_start:(roi_adj_row_start+127),roi_adj_col_start:(roi_adj_col_start+127),(rnd-1)*200+1:rnd*200);
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
for i = 1:T
    for x = 1:d2
        for y = 1:d1
            if (((y-adj_shifts_r(i,1))>0) && ((y-adj_shifts_r(i,1))<=d1) && ((x-adj_shifts_r(i,2))>0) && ((x-adj_shifts_r(i,2))<=d2))
                Yf_mc(y,x,i) = Yf(y-adj_shifts_r(i,1),x-adj_shifts_r(i,2),i);
            end
        end
    end
end


