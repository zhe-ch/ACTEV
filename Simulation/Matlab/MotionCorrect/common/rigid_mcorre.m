function shifts_g = rigid_mcorre(Y,options,template)

% online motion correction through DFT subpixel registration
% Based on the dftregistration.m function from Manuel Guizar and Jim Fienup

% INPUTS
% Y:                Input data, can be already loaded in memory as a 3D
%                   tensor, a memory mapped file, or a pointer to a tiff stack
% options:          options structure for motion correction (optional, rigid registration is performed if not provided)
% template:         provide template (optional)

% OUTPUTS
% M_final:          motion corrected data
% shifts_g          originally calculated shifts
% template:         calculated template

sizY = size(Y);
T = sizY(end);

nd = length(sizY)-1;  % determine whether imaging is 2d or 3d
sizY = sizY(1:nd);

if ~exist('options','var') || isempty(options)
    options = NoRMCorreSetParms('d1',sizY(1),'d2',sizY(2));
    if nd > 2; options.d3 = sizY(3); end
end

grid_size = options.grid_size; 
mot_uf = options.mot_uf;
min_patch_size = options.min_patch_size;
overlap_pre = options.overlap_pre;
overlap_post = options.overlap_post;
bin_width = options.bin_width;
max_dev_g = options.max_dev;
us_fac = options.us_fac;
iter = options.iter;
add_value = options.add_value;
max_shift = options.max_shift;

while mod(T,bin_width) == 1
    if T == 1
        error('Movie appears to have only one frame. Use the function normcorre instead')        
    end
    bin_width = bin_width + 1;
end

% perm = 1:33:990;
% if nd == 2 
%     Y_temp = Y(:,:,perm); 
% elseif nd == 3
%     Y_temp = Y(:,:,:,perm); 
% end
% Y_temp = single(Y_temp);
Y_temp = Y;

if nargin < 3 || isempty(template)
    template_in = median(Y_temp,nd+1)+add_value;
else
    template_in = single(template + add_value);
end

[d1,d2,d3,~] = size(Y_temp);
if nd == 2 
    d3 = 1; 
end

[xx_s,xx_f,yy_s,yy_f,zz_s,zz_f,xx_us,xx_uf,yy_us,yy_uf,zz_us,zz_uf] = construct_grid(grid_size,mot_uf,d1,d2,d3,min_patch_size);
shifts_g = struct('shifts',cell(T,1),'shifts_up',cell(T,1),'diff',cell(T,1));
temp_cell = mat2cell_ov(template_in,xx_us,xx_uf,yy_us,yy_uf,zz_us,zz_uf,overlap_post,sizY);

%% precompute some quantities that are used repetitively for template matching and applying shifts
Nr = cell(size(temp_cell));
Nc = cell(size(temp_cell));
Np = cell(size(temp_cell));
Bs = cell(size(temp_cell));
for i = 1:length(xx_us)
    for j = 1:length(yy_us)
        for k = 1:length(zz_us)
            [nr,nc,np] = size(temp_cell{i,j,k});
            nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
            nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
            np = ifftshift(-fix(np/2):ceil(np/2)-1);
            [Nc{i,j,k},Nr{i,j,k},Np{i,j,k}] = meshgrid(nc,nr,np);
            extended_grid = [max(xx_us(i)-overlap_post(1),1),min(xx_uf(i)+overlap_post(1),d1),max(yy_us(j)-overlap_post(2),1),min(yy_uf(j)+overlap_post(2),d2),max(zz_us(k)-overlap_post(3),1),min(zz_uf(k)+overlap_post(3),d3)];            
            Bs{i,j,k} = permute(construct_weights([xx_us(i),xx_uf(i),yy_us(j),yy_uf(j),zz_us(k),zz_uf(k)],extended_grid),[2,1,3]); 
        end
    end
end

maxNumCompThreads(1);
template = mat2cell_ov(template_in,xx_s,xx_f,yy_s,yy_f,zz_s,zz_f,overlap_pre,sizY);

temp_mat = template_in;
use_windowing = options.use_windowing;
phase_flag = options.phase_flag;

if use_windowing
    fftTemp = cellfun(@fftn,cellfun(@han,template,'un',0),'un',0);
    fftTempMat = fftn(han(temp_mat));
else
    fftTemp = cellfun(@fftn,template,'un',0);
    fftTempMat = fftn(temp_mat);
end

fprintf('Template initialization complete. \n')

prevstr = [];
for it = 1:iter
    for t = 1:bin_width:T
        if nd == 2
            Ytm = single(Y(:,:,t:min(t+bin_width-1,T)));
        end
        if nd == 3
            Ytm = single(Y(:,:,:,t:min(t+bin_width-1,T)));
        end
        if nd == 2
            Ytc = mat2cell(Ytm,d1,d2,ones(1,size(Ytm,ndims(Ytm)))); 
        end
        if nd == 3
            Ytc = mat2cell(Ytm,d1,d2,d3,ones(1,size(Ytm,ndims(Ytm))));
        end
        lY = length(Ytc);
        shifts = struct('shifts',cell(lY,1),'shifts_up',cell(lY,1),'diff',cell(lY,1));
        for ii = 1:lY
            Yt = Ytc{ii};
            Yc = mat2cell_ov(Yt,xx_s,xx_f,yy_s,yy_f,zz_s,zz_f,overlap_pre,sizY);
            if use_windowing
                fftY = cellfun(@fftn, cellfun(@han,Yc, 'un',0),'un',0);
            else
                fftY = cellfun(@fftn, Yc, 'un',0);
            end
            M_fin = cell(length(xx_us),length(yy_us),length(zz_us));
            shifts_temp = zeros(length(xx_s),length(yy_s),length(zz_s),nd);
            shifts_sub_temp = zeros(length(xx_s),length(yy_s),length(zz_s),nd);
            diff_temp = zeros(length(xx_s),length(yy_s),length(zz_s));
            if numel(M_fin) > 1      
                if use_windowing
                    if nd == 2
                        out_rig = fft_registration(fftTempMat,fftn(han(Yt)),us_fac,-max_shift,max_shift); 
                        lb = out_rig(3:4); 
                        ub = out_rig(3:4); 
                    end
                    if nd == 3
                        out_rig = dftregistration_min_max_3d(fftTempMat,fftn(han(Yt)),us_fac,-max_shift,max_shift,phase_flag); 
                        lb = out_rig(3:5); 
                        ub = out_rig(3:5); 
                    end
                else
                    if nd == 2
                        out_rig = fft_registration(fftTempMat,fftn(Yt),us_fac,-max_shift,max_shift);
                        lb = out_rig(3:4);
                        ub = out_rig(3:4);
                    end
                    if nd == 3
                        out_rig = dftregistration_min_max_3d(fftTempMat,fftn(Yt),us_fac,-max_shift,max_shift,phase_flag);
                        lb = out_rig(3:5);
                        ub = out_rig(3:5);
                    end
                end
                max_dev = max_dev_g;
            else
                lb = -max_shift(1,nd);
                ub = max_shift(1,nd);
                max_dev = 0*max_dev_g;
            end
            for i = 1:length(xx_s)
                for j = 1:length(yy_s)           
                    for k = 1:length(zz_s)
                        if nd == 2
                            output = fft_registration(fftTemp{i,j,k},fftY{i,j,k},us_fac,lb-max_dev(1:2),ub+max_dev(1:2));  
                        elseif nd == 3
                            output = dftregistration_min_max_3d(fftTemp{i,j,k},fftY{i,j,k},us_fac,lb-max_dev,ub+max_dev,phase_flag); 
                            shifts_temp(i,j,k,3) = output(5);
                        end
                        shifts_temp(i,j,k,1) = output(3);
                        shifts_temp(i,j,k,2) = output(4);
                        shifts_sub_temp(i,j,k,1) = output(5);
                        shifts_sub_temp(i,j,k,2) = output(6);
                        diff_temp(i,j,k) = output(2);                                              
                    end
                end
            end 
            
            shifts(ii).shifts = shifts_temp;
            shifts(ii).diff = diff_temp;

            if any([length(xx_s),length(yy_s),length(zz_s)] > 1)          
                if mot_uf(3) > 1                
                    tform = affine3d(diag([mot_uf(:);1]));
                    diff_up = imwarp(diff_temp,tform,'OutputView',imref3d([length(xx_uf),length(yy_uf),length(zz_uf)]));
                    shifts_up = zeros([size(diff_up),3]);
                    for dm = 1:3
                        shifts_up(:,:,:,dm) = imwarp(shifts_temp(:,:,:,dm),tform,'OutputView',imref3d([length(xx_uf),length(yy_uf),length(zz_uf)])); 
                    end
                else                    
                    shifts_up = imresize(shifts_temp,[length(xx_uf),length(yy_uf)]);
                    diff_up = imresize(diff_temp,[length(xx_uf),length(yy_uf)]);                    
                end
                shifts(ii).shifts_up = shifts_up;
                shifts(ii).diff = diff_up;
            else
                shifts(ii).shifts_up = shifts(ii).shifts;
            end
        end
        
        shifts_g(t:min(t+bin_width-1,T)) = shifts;
        
        str = [num2str(t+lY-1), ' out of ', num2str(T), ' frames registered, iteration ', num2str(it), ' out of ', num2str(iter), '..'];
        refreshdisp(str, prevstr, t);
        prevstr = str;
    end
    fprintf("\n");
    
    if it == iter
        template = cellfun(@(x) x - add_value,template,'un',0);
        template = cell2mat_ov(template,xx_s,xx_f,yy_s,yy_f,zz_s,zz_f,overlap_pre,sizY);
    end

    maxNumCompThreads('automatic');
end
    