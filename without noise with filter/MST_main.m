clear All;
close all;
clc;

addpath(genpath('lib'));

addpath(genpath('imageFusionMetrics-master_modified'));

addpath(genpath('dtcwt_toolbox'));
addpath(genpath('sparsefusion'));
addpath(genpath('fdct_wrapping_matlab'));
addpath(genpath('nsct_toolbox'));

% reference image (ground truth)
[file,path] = uigetfile('*.*', 'Select an image file');
imt = double(imread(strcat(path,'\',file)));

figure(1);imshow(imt,[]);title('original image');
ent_imt=entropy(uint8(imt));

%images to be fused
[file,path] = uigetfile('*.*', 'Select an image file');
im1 = double(imread(strcat(path,'\',file)));
figure(2); imshow(im1,[]);
title('Output Image 1');

% level=6;
% for groundtruth image
ent_imt=entropy(uint8(imt));
fprintf('\n Ground truth image entropy:%d',ent_imt);
mn_imt=mean(mean(double(imt)));
fprintf('\n Ground truth image mean:%f',mn_imt);


% for im1 image
ent_im1=entropy(uint8(im1));
fprintf('\n IM1 image entropy:%d',ent_im1);
mn_im1=mean(mean(double(im1)));
fprintf('\n IM1 image mean:%f',mn_im1);





e=imt-im1;
ent_e=entropy(uint8(e));
fprintf('\n entropy between imt and im1 :%f',ent_e);

figure(3); imshow(e,[]);
title('Difference image');

 %Mean Square Error
 MSE = MeanSquareError(imt, im1);
 fprintf('\n MSE between imt and im1 :%f',MSE);


 %Average Difference 
 AD = AverageDifference(imt, im1);
 fprintf('\n Average Difference between imt and im1 :%f',AD);

 %Maximum Difference 
 MD = MaximumDifference(imt, im1);
 fprintf('\n Maximum Difference between imt and im1 :%f',MD);

 %Normalized Absolute Error
 NAE = NormalizedAbsoluteError(imt, im1);
 fprintf('\n Normalized Absolute Error between imt and im1 :%f',NAE);

%%% NOT NECESSORY WITH RMSE
 
 % e=imt-im1;
 % RMSE = mean(e(:).^2);%root mean square error
%  fprintf('\n RMSE between imt and im1 :%f',RMSE);


 % % displaying values

%%%% for original image

[TP1, FP1, TN1, FN] = calError(imt, im1); % canny with s-func

NI1=nnz(Ibin);
NB1=nnz(Ibin);
% The percentage of pixels that were correctly detected (Pco):
Pco1=TP1/max(NI1,NB1);

% The percentage of pixels that were not detected (Pnd):
Pnd1=FNori/max(NI1,NB1);

% The percentage of pixels that were erroneously detected as edge pixels, ie the percentage of false alarm: (Pfa):
Pfa1=FP1/max(NI1,NB1);

% The figure of merit of Pratt, which assesses the similarity between two contours is defined as: (IMP)

IMP1=pratt(logical(Ibin),logical(Ibin));
% IMPori=0.0;
% The distance defined d4^2 varies between 0 and 2, where the value 0 represents the perfect fit for this measure
% the best edge detector among several detectors will minimize this distance.
D41=globalindex(Pco1,IMP1,Pnd1,Pfa1);

% displaying ideal values
fprintf(' Original image ideal values:\n');
fprintf('True Positive values:%f \n', TP1);
fprintf('False Positive values: %f \n',FP1);

fprintf('True Negative values:%f\n',TN1);
fprintf('False Negative values:%f \n', FNori);

fprintf('percentage of pixels that were correctly detected (Pco): %f\n',Pco1);

fprintf('The percentage of pixels that were not detected (Pnd):%f \n',Pnd1);

fprintf('the percentage of false alarm: (Pfa):%f \n',Pfa1);

fprintf('figure of merit of Pratt:(IMP): %f \n',IMP1);

fprintf('Eucledian Distance(d^4): %f \n',D41);


