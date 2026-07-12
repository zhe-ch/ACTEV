function imgData = readTiff(filename)

info = imfinfo(filename);
numFrames = numel(info);

imgData = zeros(info(1).Height, info(1).Width, numFrames, 'uint16');

for n = 1:numFrames
    imgData(:,:,n) = imread(filename, n);
end

end