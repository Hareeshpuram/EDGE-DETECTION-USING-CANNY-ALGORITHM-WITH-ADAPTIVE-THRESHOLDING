clc;
clear;
close All;
% sample initial 
i=0;Tl=0;Th=0;a=zeros();b=zeros();
% reading input image of both color and gray scale
[filename,pathname]=uigetfile('*.*','select an image');
[file,path] =uigetfile('*.*', 'Select an image file');
I1=imread(strcat(pathname,'\',filename));
[m,n,d]=size(I1);
if d==3
I2=rgb2gray(I1);
else
I2=I1;
end
I = double(I2)/255;
nl=[0.1 10 20 30 40 50 60 70 80];

for j=1:9
l=nl(j);
%Thresholding Algorithms                                           
tl=adaptthresh(I2,0.5,"NeighborhoodSize",11,"Statistic","mean");  

th=tl/6;

[J,In,fi ,np] = canny_edge_detection(I, 0.8,tl,th,l);
fprintf('\n\n%s\tnoise:%.1f\n',filename,np);
figure;
subplot(2,3,1); imshow(I1);
title('Original Image');
subplot(2,3,2); imshow(I);
title('Gray Scale Image');
subplot(2,3,3); imshow(In);
title(sprintf('image with  %.1f%%noise',np));
subplot(2,3,4); imshow(fi);
title('filtered Image');
subplot(2,3,5); imshow(J);
title('Image With Edges');

%%% % % % % % % % % % % % % % % % % % % % % % % % % % % % %%%
%%% % % % % % % % % % % % % % % % % % % % % % % % % % % % %%%
% %                                                       % %
% %         Parameters For Edge Detection                 % %
% %                                                       % %
%%% % % % % % % % % % % % % % % % % % % % % % % % % % % % %%%
%%% % % % % % % % % % % % % % % % % % % % % % % % % % % % %%% 

% reference image (ground truth)
%[file,path] =uigetfile('*.*', 'Select an image file');
imt = logical(imread(strcat(path,'\',file)));
imt = double(imt);
% level=6;
% for groundtruth image
ent_imt=entropy(uint8(imt));
mn_imt=mean(mean(double(imt)));

% for im1 image
ent_im1=entropy(uint8(J));
mn_im1=mean(mean(double(J)));
e=imt-J;
ent_e=entropy(uint8(e));
 
 % Mean Square Error
 MSE = MeanSquareError(imt, J);

 % Average Difference 
 AD = AverageDifference(imt, J);

 % Maximum Difference 
 MD = MaximumDifference(imt, J);
 
% for original image
[TP1, FP1, TN1, FN1] = calError(imt, J);

NI1=nnz(imt);
NB1=nnz(J);
% The percentage of pixels that were correctly detected (Pco):
Pco1=TP1/max(NI1,NB1);

% The percentage of pixels that were not detected (Pnd):
Pnd1=FN1/max(NI1,NB1);

% The percentage of pixels that were erroneously detected as edge pixels, ie the percentage of false alarm: (Pfa):
Pfa1=FP1/max(NI1,NB1);

% The figure of merit of Pratt, which assesses the similarity between two contours is defined as: (IMP)
IMP1=pratt(logical(imt),logical(J));

% IMPori=0.0;
% The distance defined d4^2 varies between 0 and 2, where the value 0 represents the perfect fit for this measure
% the best edge detector among several detectors will minimize this distance.
% Euclidean Distance
D41=globalindex(Pco1,IMP1,Pnd1,Pfa1);

%Accuracy
Accuracy=(TP1+TN1)/(TP1+TN1+FN1+FP1);

%F- Measure 
F1=TP1/(TP1+0.5*(FP1+FN1));

% %PSNR
PSNR=psnr(J,imt);

%SNR
SNR=snr(J,imt);
% displaying ideal values

fprintf('\n\nOriginal image ideal values:\n \n');
fprintf('noise:%.1f\n',np)
fprintf('IM1 image entropy:%d \n',ent_im1);
fprintf('IM1 image mean:%f \n',mn_im1);
fprintf('Ground truth image entropy:%f \n',ent_imt);
fprintf('Ground truth image mean:%f \n',mn_imt);
fprintf('entropy between imt and im1 :%f \n',ent_e);
fprintf('MSE between imt and im1 :%f \n',MSE);
fprintf('Average Difference between imt and im1 :%f \n',AD);
fprintf('Maximum Difference between imt and im1 :%f \n',MD);
fprintf('True Positive values:%f \n', TP1);
fprintf('False Positive values: %f \n',FP1);
fprintf('True Negative values:%f\n',TN1);
fprintf('False Negative values:%f \n', FN1);
fprintf('Accuracy value: %f \n',Accuracy);
fprintf('F Measure values:%f \n', F1);
fprintf('Peak Signal-to Noise Ration value: %f \n',PSNR);
fprintf('Signal-to Noise Ration value: %f \n',SNR);
fprintf('percentage of pixels that were correctly detected (Pco): %f\n',Pco1);
fprintf('The percentage of pixels that were not detected (Pnd):%f \n',Pnd1);
fprintf('the percentage of false alarm: (Pfa):%f \n',Pfa1);
fprintf('Euclidean Distance Value :%f \n',D41);
fprintf('\n\n')

end
