function output = fft_registration(buf1ft,buf2ft,usfac,min_shift,max_shift)

% Efficient subpixel image registration by crosscorrelation. This code
% gives the same precision as the FFT upsampled cross correlation in a
% small fraction of the computation time and with reduced memory 
% requirements. It obtains an initial estimate of the crosscorrelation peak
% by an FFT and then refines the shift estimation by upsampling the DFT
% only in a small neighborhood of that estimate by means of a 
% matrix-multiply DFT. With this procedure all the image points are used to
% compute the upsampled crosscorrelation. When usfac=1, interpolation is 
% leveraged to achieve sub-pixel resolution.
%
% Inputs
% buf1ft    Fourier transform of reference image, 
%           DC in (1,1)   [DO NOT FFTSHIFT]
% buf2ft    Fourier transform of image to register, 
%           DC in (1,1) [DO NOT FFTSHIFT]
% usfac     Upsampling factor (integer). Images will be registered to 
%           within 1/usfac of a pixel. For example usfac = 20 means the
%           images will be registered within 1/20 of a pixel. (default = 1)
% max_shift Maximum shift in each dimension (2x1 vector). (default = Inf, no max)
%
% Outputs
% output =  [error,diffphase,row_shift,col_shift,row_shift_sub,col_shift_sub]
% error     Translation invariant normalized RMS error between f and g
% diffphase     Global phase difference between the two images (should be
%               zero if images are non-negative).
% row_shift, col_shift   Pixel shifts between images
% row_shift_sub, col_shift_sub   Sub-pixel shifts between images

if ~exist('usfac','var')
    usfac = 1;
end

if ~exist('max_shift','var')
    min_shift = -Inf(1,2);
end

if ~exist('max_shift','var')
    max_shift = Inf(1,2);
end

if isscalar(min_shift)
    min_shift = min_shift*[1,1]; 
end

if isscalar(max_shift)
    max_shift = max_shift*[1,1]; 
end

[nr, nc] = size(buf2ft);
Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);

buf_prod = buf1ft.*conj(buf2ft);

if usfac == 0
    % Simply compute the error without registration
    CCmax = sum(buf1ft(:).*conj(buf2ft(:)));
    row_shift = 0;
    col_shift = 0;
    row_shift_sub = 0;
    col_shift_sub = 0;
elseif usfac == 1
    % Sub pixel registration with interpolation
    CC = ifft2(buf_prod);
    CCabs = abs(CC);
    if (max(CCabs(:)) ~= 0)
        [row_shift, col_shift] = find(CCabs == max(CCabs(:)),1,'first');
    else
        row_shift = 1;
        col_shift = 1;
    end
    
    if (Nr(row_shift) > max_shift(1) || Nc(col_shift) > max_shift(2) || Nr(row_shift) < min_shift(1) || Nc(col_shift) < min_shift(2))
        CCabs2 = CCabs;
        CCabs2(Nr>max_shift(1),:) = 0;
        CCabs2(:,Nc>max_shift(2)) = 0;
        CCabs2(Nr<min_shift(1),:) = 0;
        CCabs2(:,Nc<min_shift(2)) = 0;
        [row_shift, col_shift] = find(CCabs == max(CCabs2(:)),1,'first');
    end    
    CCmax = CC(row_shift,col_shift)*nr*nc;
    % Now change shifts so that they represent relative shifts and not indices
    [width, height] = size(CCabs);
    
    if (row_shift == 1)
        xm1_pos = width;
        xp1_pos = 2;
    elseif (row_shift == width)
        xm1_pos = width - 1;
        xp1_pos = 1;
    else
        xm1_pos = row_shift - 1;
        xp1_pos = row_shift + 1;
    end
    
    if (col_shift == 1)
        ym1_pos = height;
        yp1_pos = 2;
    elseif (col_shift == height)
        ym1_pos = height - 1;
        yp1_pos = 1;
    else
        ym1_pos = col_shift - 1;
        yp1_pos = col_shift + 1;
    end
    
    log_xm1_y = log(CCabs(xm1_pos, col_shift));
    log_xp1_y = log(CCabs(xp1_pos, col_shift));
    log_x_ym1 = log(CCabs(row_shift, ym1_pos));
    log_x_yp1 = log(CCabs(row_shift, yp1_pos));
    four_log_xy = 4 * log(CCabs(row_shift, col_shift));    
    if (2*log_xm1_y + 2*log_xp1_y ~= four_log_xy)
        if (abs((log_xm1_y - log_xp1_y)/(2*log_xm1_y + 2*log_xp1_y - four_log_xy)) < 1)
            row_shift = Nr(row_shift);
            row_shift_sub = row_shift + (log_xm1_y - log_xp1_y)/(2*log_xm1_y + 2*log_xp1_y - four_log_xy);
        else
            row_shift = Nr(row_shift);
            row_shift_sub = row_shift;
        end
    else
        row_shift = Nr(row_shift);
        row_shift_sub = row_shift;
    end
    if (2*log_x_ym1 + 2*log_x_yp1 ~= four_log_xy)
        if (abs((log_x_ym1 - log_x_yp1)/(2*log_x_ym1 + 2*log_x_yp1 - four_log_xy)) < 1)
            col_shift = Nc(col_shift);
            col_shift_sub = col_shift + (log_x_ym1 - log_x_yp1)/(2*log_x_ym1 + 2*log_x_yp1 - four_log_xy);
        else
            col_shift = Nc(col_shift);
            col_shift_sub = col_shift;
        end
    else
        col_shift = Nc(col_shift);
        col_shift_sub = col_shift;
    end
elseif usfac > 1
    % Start with usfac == 2
    buf_pad = FTpad(buf_prod, [2*nr, 2*nc]);
    CC = ifft2(buf_pad);
    CCabs = abs(CC);
    [row_shift, col_shift] = find(CCabs == max(CCabs(:)),1,'first');
    % Now change shifts so that they represent relative shifts and not indices
    Nr2 = ifftshift(-fix(nr):ceil(nr)-1);
    Nc2 = ifftshift(-fix(nc):ceil(nc)-1);
    if (Nr2(row_shift)/2 > max_shift(1) || Nc2(col_shift)/2 > max_shift(2) || Nr2(row_shift)/2 < min_shift(1) || Nc2(col_shift)/2 < min_shift(2))
        CCabs2 = CCabs;
        CCabs2(Nr2/2>max_shift(1),:) = 0;
        CCabs2(:,Nc2/2>max_shift(2)) = 0;
        CCabs2(Nr2/2<min_shift(1),:) = 0;
        CCabs2(:,Nc2/2<min_shift(2)) = 0;
        [row_shift, col_shift] = find(CCabs == max(CCabs2(:)),1,'first');
    end
    CCmax = CC(row_shift, col_shift) * nr * nc;
    row_shift = Nr2(row_shift) / 2;
    col_shift = Nc2(col_shift) / 2;
    row_shift_sub = row_shift;
    col_shift_sub = col_shift;
    
    % If upsampling > 2, then refine estimate with matrix multiply DFT
    if usfac > 2
        % DFT computation %
        % Initial shift estimate in upsampled grid
        row_shift = round(row_shift * usfac) / usfac; 
        col_shift = round(col_shift * usfac) / usfac;     
        dftshift = fix(ceil(usfac * 1.5) / 2); %% Center of output array at dftshift+1
        % Matrix multiply DFT around the current shift estimate
        CC = conj(dftups(buf2ft.*conj(buf1ft),ceil(usfac*1.5),ceil(usfac*1.5),usfac,...
            dftshift-row_shift*usfac,dftshift-col_shift*usfac));
        % Locate maximum and map back to original pixel grid 
        CCabs = abs(CC);
        [rloc, cloc] = find(CCabs == max(CCabs(:)),1,'first');
        CCmax = CC(rloc,cloc);
        rloc = rloc - dftshift - 1;
        cloc = cloc - dftshift - 1;
        row_shift = row_shift + rloc/usfac;
        col_shift = col_shift + cloc/usfac;
        row_shift_sub = row_shift;
        col_shift_sub = col_shift;
    end
    
    if nr == 1
        row_shift = 0;
        row_shift_sub = 0;
    end
    if nc == 1
        col_shift = 0;
        col_shift_sub = 0;
    end
end

%rg00 = sum(abs(buf1ft(:)).^2);
%rf00 = sum(abs(buf2ft(:)).^2);
%error = 1.0 - abs(CCmax).^2/(rg00*rf00);
%error = sqrt(abs(error));
error = 1;
diffphase = angle(CCmax);

output=[error,diffphase,row_shift,col_shift,row_shift_sub,col_shift_sub];

function out=dftups(in,nor,noc,usfac,roff,coff)
% function out=dftups(in,nor,noc,usfac,roff,coff);
% Upsampled DFT by matrix multiplies, can compute an upsampled DFT in just
% a small region.
% usfac         Upsampling factor (default usfac = 1)
% [nor,noc]     Number of pixels in the output upsampled DFT, in
%               units of upsampled pixels (default = size(in))
% roff, coff    Row and column offsets, allow to shift the output array to
%               a region of interest on the DFT (default = 0)
% Recieves DC in upper left corner, image center must be in (1,1) 
% Manuel Guizar - Dec 13, 2007
% Modified from dftus, by J.R. Fienup 7/31/06

% This code is intended to provide the same result as if the following
% operations were performed
%   - Embed the array "in" in an array that is usfac times larger in each
%     dimension. ifftshift to bring the center of the image to (1,1).
%   - Take the FFT of the larger array
%   - Extract an [nor, noc] region of the result. Starting with the 
%     [roff+1 coff+1] element.

% It achieves this result by computing the DFT in the output array without
% the need to zeropad. Much faster and memory efficient than the
% zero-padded FFT approach if [nor noc] are much smaller than [nr*usfac nc*usfac]

[nr,nc]=size(in);
% Set defaults
if exist('roff', 'var')~=1
    roff=0;  
end

if exist('coff', 'var')~=1
    coff=0;  
end

if exist('usfac','var')~=1
    usfac=1; 
end

if exist('noc',  'var')~=1 
    noc=nc;  
end

if exist('nor',  'var')~=1
    nor=nr;  
end

% Compute kernels and obtain DFT by matrix products
kernc = exp((-1i*2*pi/(nc*usfac))*(ifftshift(0:nc-1).'-floor(nc/2))*((0:noc-1)-coff));
kernr = exp((-1i*2*pi/(nr*usfac))*((0:nor-1).'-roff)*(ifftshift(0:nr-1)-floor(nr/2)));
out = kernr * in * kernc;

return

function imFTout = FTpad(imFT,outsize)
% imFTout = FTpad(imFT,outsize)
% Pads or crops the Fourier transform to the desired ouput size. Taking 
% care that the zero frequency is put in the correct place for the output
% for subsequent FT or IFT. Can be used for Fourier transform based
% interpolation, i.e. dirichlet kernel interpolation. 
%
% Inputs
% imFT      - Input complex array with DC in [1,1]
% outsize   - Output size of array [ny nx] 
%
% Outputs
% imout   - Output complex image with DC in [1,1]
% Manuel Guizar - 2014.06.02

if ~ismatrix(imFT)
    error('Maximum number of array dimensions is 2')
end
Nout = outsize;
Nin = size(imFT);
imFT = fftshift(imFT);
center = floor(size(imFT)/2)+1;

imFTout = zeros(outsize);
centerout = floor(size(imFTout)/2)+1;

% imout(centerout(1)+[1:Nin(1)]-center(1),centerout(2)+[1:Nin(2)]-center(2)) ...
%     = imFT;
cenout_cen = centerout - center;
imFTout(max(cenout_cen(1)+1,1):min(cenout_cen(1)+Nin(1),Nout(1)),max(cenout_cen(2)+1,1):min(cenout_cen(2)+Nin(2),Nout(2))) ...
    = imFT(max(-cenout_cen(1)+1,1):min(-cenout_cen(1)+Nout(1),Nin(1)),max(-cenout_cen(2)+1,1):min(-cenout_cen(2)+Nout(2),Nin(2)));

imFTout = ifftshift(imFTout)*Nout(1)*Nout(2)/(Nin(1)*Nin(2));

return

