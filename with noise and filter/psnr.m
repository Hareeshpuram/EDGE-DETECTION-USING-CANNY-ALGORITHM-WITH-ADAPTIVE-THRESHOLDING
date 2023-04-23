function [peaksnr, snr] = psnr(A, ref, peakval,NameValueArgs)
%PSNR Peak Signal-To-Noise Ratio.
%   PEAKSNR = PSNR(A, REF) calculates the peak signal-to-noise ratio for
%   the image in array A, with the image in array REF as the reference. A
%   and REF can be N-D arrays, and must be of the same size and class.
% 
%   PEAKSNR = PSNR(A, REF, PEAKVAL) uses PEAKVAL as the peak signal value
%   for calculating the peak signal-to-noise ratio.
% 
%   [PEAKSNR, SNR] = PSNR(A, REF, __) also returns the simple
%   signal-to-noise in SNR, in addition to the peak signal-to-noise ratio.
%
%   [___] = PSNR(___,Name,Value) accepts name value pairs to control aspects
%   of computation. Supported options include:
%
%       'DataFormat'            Dimension labels of the input data A and REF
%                               specified as a string scalar or character
%                               vector. The format options 'S','C', and 'B' 
%                               are supported. The options 'S', 'C' and 'B' 
%                               correspond to spatial, channel, and batch 
%                               dimensions, respectively. For data with a 
%                               batch or 'B' dimension, the output PEAKSNR 
%                               and SNR will contain a separate result for 
%                               each index along the batch dimension.
%                               As an example, input RGB data with two
%                               spatial dimensions and one channel
%                               dimension would have a 'SSC' DataFormat.
%                               Default: All input dimensions in A treated as
%                               spatial dimensions.
%  
%   Notes
%   -----
%   1. When dlarray input is labeled and contains a batch dimension, psnr
%   yields a separate result for each element along the batch dimension.
%
%   Class Support
%   -------------
%   Input arrays A and REF must be one of the following classes: uint8,
%   int16, uint16, single, or double. Both A and REF must be of the same
%   class. They must be nonsparse. PEAKVAL is a scalar of any numeric
%   class. PEAKSNR and SNR are scalars of class double, unless A and REF
%   are of class single in which case PEAKSNR and SNR are scalars of class
%   single.
%
%   Example
%   ---------
%  % This example shows how to compute PSNR for noisy image given the
%  % original reference image.
% 
%   ref = imread('pout.tif');
%   A = imnoise(ref,'salt & pepper', 0.02);
% 
%   [peaksnr, snr] = psnr(A, ref);
% 
%   fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
%   fprintf('\n The SNR value is %0.4f \n', snr);
%
%   See also IMMSE, MEAN, MEDIAN, SSIM, SUM, VAR.

%   Copyright 2013-2021 The MathWorks, Inc. 

arguments
    A {mustBeA(A,{'uint8','uint16','int16','single','double','gpuArray'}),mustBeNonsparse mustBeReal}
    ref {mustBeA(ref,{'uint8','uint16','int16','single','double','gpuArray'}),mustBeNonsparse mustBeReal}
    peakval = diff(getrangefromclass(A))
    NameValueArgs.DataFormat char {images.internal.qualitymetric.validateDataFormat} = repmat('S',1,ndims(A));
end

checkImages(A,ref);

checkPeakval(peakval, A);
peakval = double(peakval);

perm = images.internal.qualitymetric.permuteFormattedDims(A,NameValueArgs.DataFormat);
A = permute(A,perm);
ref = permute(ref,perm);

hasBatchDim = ~isempty(find(NameValueArgs.DataFormat == 'B',1));

if nargout < 2
peaksnr = images.internal.qualitymetric.psnralgo(A, ref, peakval,hasBatchDim,@log10);
else
    [peaksnr,snr] = images.internal.qualitymetric.psnralgo(A, ref, peakval,hasBatchDim,@log10);
    snr = ipermute(snr,perm);
end

peaksnr = ipermute(peaksnr,perm);

end

function checkImages(A, ref)

if ~isa(A,class(ref))
    error(message('images:validate:differentClassMatrices','A','REF'));
end   
if ~isequal(size(A),size(ref))
    error(message('images:validate:unequalSizeMatrices','A','REF'));
end

end

function checkPeakval(peakval, A)

validateattributes(peakval,{'numeric'},{'nonnan', 'real', ...
    'nonnegative','nonsparse','nonempty','scalar'}, mfilename, ...
    'PEAKVAL',3);
if isinteger(A) && (peakval > diff(getrangefromclass(A)))
    warning(message('images:psnr:peakvalTooLarge', 'A', 'REF'));
end

end
