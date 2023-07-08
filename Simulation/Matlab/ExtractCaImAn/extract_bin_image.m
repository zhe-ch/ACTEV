%=====================================================
% FileName: extract_bin_image.m
% Designby: Zhe
% Modified: 11/4/2021
% Describe: Extract all frames of images from TIFF and store in image.bin
%==========================================================================

clear variables;

file_path = "/media/blairlab/Seagate Expansion Drive/RealTimeFiles/";
file_name = "Hipp15_linear8_win.tif";
name = strcat(file_path, file_name);

tiffInfo = imfinfo(name);
T = numel(tiffInfo);
TIFF_CNT = floor(T / 1000);

d1 = 512;
d2 = 512;

Yf = zeros(d1, d2, 1000);
fileID = fopen('image.bin', 'w');

% Load images from TIFF stack
for r = 1:TIFF_CNT
    for t = 1:1000
        Yf(:,:,t) = imread(name, 'Index', (r-1)*1000+t);
    end
    Yf = single(Yf);

    % Write back motion corrected images to TIFF stack
    % store image in row-major order
    Yf = permute(Yf, [2,1,3]);

    % write image data into a file
    fwrite(fileID, Yf(:,:,:));
end

Yf = zeros(d1, d2, T-TIFF_CNT*1000);
for t = 1:T-TIFF_CNT*1000
    Yf(:,:,t) = imread(name, 'Index', TIFF_CNT*1000+t);
end
Yf = single(Yf);

% Write back motion corrected images to TIFF stack
% store image in row-major order
Yf = permute(Yf, [2,1,3]);
    
% write image data into a file
fwrite(fileID, Yf(:,:,:));
    
fclose(fileID);
