function imgData = readBin(filename, width, height, numFrames, dataType)

fid = fopen(filename, 'rb');
assert(fid ~= -1, strcat('[Error] Cannot open file: ', filename));

imgData = fread(fid, width*height*numFrames, ['*', dataType]);
fclose(fid);

imgData = reshape(imgData, width, height, numFrames);
imgData = permute(imgData, [2 1 3]);

end