% - - - - - - - - - - - - - - - - - - - - - - - - - - 
% This script perfoms the Bilateral Histogram Equalization < ICIP 2019 >
%
% Authors : Tahani Madmad and Christophe De Vleeschouwer (c) , UCLouvain/ICTEAM
%
% e - mail : tahani.madmad@uclouvain.be
%
% Created : October,2017 , using Matlab 9.2.0.556344 (R2017a)
% Last update : February, 2019 , using Matlab 9.2.0.556344 (R2017a)
% - - - - - - - - - - - - - - - - - - - - - - - - - - 
close all , clear all , clc;
%--------Load and read a DICOM :
[filename, pathname] = uigetfile({'*.dcm'},'File Selector');
inputImg = double(dicomread(strcat(pathname,filename)));

%--------Display the input HDR image : 
clf(figure);imshow(inputImg,[]);title('Input HDR image');colorbar;
[M,N] = size(inputimg);
%------- BHE Parameters
nbrBins = 30;
sigmaSpatial = (M+N)/20;
sigmaRange = 0.2;
cl = 1; % cl = 1 : performs BHE-cl & cl= 0 performs BHE w/o clipping the weightmaps

% ------ BHEcl Parameter
clipThreshold = 0.2;

% ------ Bilateral Histogram Equalization
[ imgBHE, imgBHEcl] = BilateralHistogramEqualization (inputImg,nbrBins, cl, sigmaSpatial, sigmaRange, clipThreshold) ;

% ------ Results
clf(figure); imshow(BHE,[]); colorbar;
title(sprintf('BHE S_s=%2.d, S_r=%1.d, it = %1.d',sigmaSpatial,sigmaRange, iter));colorbar;

clf(figure); imshow(BHEcl,[]);colorbar;
title(sprintf('BHE CLAHE S_s=%2.d, S_r=%d, it = %3.d, Inf=%3d, Sup=%d',sigmaSpatial,sigmaRange, iter, Seuil_inf, Seuil_sup));colorbar;
