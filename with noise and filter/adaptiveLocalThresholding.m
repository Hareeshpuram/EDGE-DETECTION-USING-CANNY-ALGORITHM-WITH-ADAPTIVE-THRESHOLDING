function [binary_image, threshold_image] = adaptiveLocalThresholding(image, window_size, sensitivity)
% ADAPTIVELOCALTHRESHOLDING computes a binary image using adaptive local thresholding.
% 
% INPUT:
%   - image: the input grayscale image
%   - window_size: the size of the local window
%   - sensitivity: a value between 0 and 1 that controls the thresholding sensitivity
%
% OUTPUT:
%   - binary_image: the computed binary image
%   - threshold_image: the computed local threshold image
%
% EXAMPLE USAGE:
%   I = imread('cameraman.tif');
%   [B, T] = adaptiveLocalThresholding(I, 15, 0.5);

% Convert image to double precision
%image = im2double(image);

% Compute local threshold using mean and standard deviation
mean_image = conv2(image, ones(window_size) / window_size^2, 'same');
var_image = conv2(image.^2, ones(window_size) / window_size^2, 'same') - mean_image.^2;
std_image = sqrt(max(var_image, 0));
threshold_image = mean_image + sensitivity * std_image;

% Compute binary image using local threshold
binary_image = image > threshold_image;
end