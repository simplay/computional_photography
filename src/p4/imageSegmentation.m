function imageSegmentation( img )
%IMAGESEGMENTATION Summary of this function goes here
%   Detailed explanation goes here


% get fore-and background separating masks.
[fmask, bmask] = selectionForeAndBackground(img);

FM = mat2Img(fmask(:,:), fmask(:,:), fmask(:,:));
BM = mat2Img(bmask(:,:), bmask(:,:), bmask(:,:));

title = 'Foreground (left) and background mask(right)';
labels = {'Foreground Mask' 'Background Mask'};
imgs = zeros(size(fmask,1), size(fmask,2), 3, 2);

imgs(:,:,:,1) = FM(:,:,:);
imgs(:,:,:,2) = BM(:,:,:);

showImgSeries(title, imgs, labels);
clc

% extract fore-and background colors from masked selection
[fcolors, bcolors, colors] = extractBackAndForeGroundColors(img, fmask, bmask);

% Fit a Gaussian mixture distribution (gmm) to data: foreground an background
componentCount = 2;
gmmForeground = fitgmdist(fcolors', componentCount);
gmmBackground = fitgmdist(bcolors', componentCount);
    
figure('name', 'foreground');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    foregroundMeanColor = reshape(gmmForeground.mu(k,:,:),1,1,3);
    imshow(imresize(foregroundMeanColor, [150,150]));
end
    
figure('name', 'background');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    backgroundMeanColor = reshape(gmmBackground.mu(k,:,:),1,1,3);
    imshow(imresize(backgroundMeanColor, [150,150]));
end

% Calculate probability density functions
foregroundPDF = pdf(gmmForeground, colors');
backgroundPDF = pdf(gmmBackground, colors');

figure('name', 'Probability pixel belongs to foreground (brigther means higher probability)');
density = reshape(foregroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);

figure('name', 'Probability pixel belongs to background (brigther means higher probability)');
density = reshape(backgroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);


end

