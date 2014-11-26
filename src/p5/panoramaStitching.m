function out = panoramaStitching( img1, img2 )
%PANORAMASTITCHING stitch two given images together to form a single
% panorama image. Assumptions: 
% each picture was shot from the same position, with the same focal length and zoom.
% ignore lens distortions, 
% then the pictures are related by a homography, more precisely by a rotation followed by a projection.
%   @param img1 (M x N x 3) image: is supposed to denote the image on the left 
%   @param img2 (M x N x 3) image: is supposed to denote the image on the right
    
    % get image resolutions
    [M, N, ~] = size(img1);
    
    % grayscale versions of given input images
    grayI1 = single(rgb2gray(img1)); grayI2 = single(rgb2gray(img2));
    
    % computes the SIFT frames: Scale-Invariant Feature Transform
    [frames_img1, descriptors_img1] = vl_sift(grayI1);
    [frames_img2, descriptors_img2] = vl_sift(grayI2);
    
    % display sift frames
    frames = {frames_img1, frames_img2};
    images = {img1, img2};
    showSIFTFrames(images, frames);
    
    % matches the two sets of SIFT descriptors descriptors_img1 and descriptors_img2.
    matches = vl_ubcmatch(descriptors_img1, descriptors_img2);
    
    % retrieved matched points
    [matchedPointsImg1, matchedPointsImg2] = retrieveMatchedPoints(frames, matches);

    bestInlierIndices = estimateBetInlierIndicesByRANSAC(matches, matchedPointsImg1, matchedPointsImg2);

    bestInliersImg1 = matchedPointsImg1(:, bestInlierIndices);
    bestInliersImg2 = matchedPointsImg2(:, bestInlierIndices);
    H = pointSets2Homography(bestInliersImg1, bestInliersImg2);
    
    % from all possible pair combinations of boundaries: gives us corner
    % points.
    [boundingBox, width, height, shiftedWidth, shiftedHeight] = computeBoundingBoxFromCorners(H,M,N);
    
    pixels = H\boundingBox;
    w = pixels(3,:);
    pixels = pixels./repmat(w,3,1); 
    
    bleedingMask = computeBlendingMask(M,N);
    
    interpolatedColorsImg1 = getBilinearInterpolatedColors(img1, pixels);
    interpolatedColorMaskImg1 = getBilinearInterpolatedColors(bleedingMask, pixels);
    
    % padded image 1 and its mask are resulting from interpolated images.
    paddedImg1 = reshape(shiftdim(interpolatedColorsImg1, 1), height, width, 3);
    paddedMaskImg1 = reshape(shiftdim(interpolatedColorMaskImg1, 1), height, width, 3);
    
    % padded image 2 and its mask (bleeding).
    postPaddedDimsOf = @(baseImg) [height-size(baseImg, 1), ...
                                   width-size(baseImg, 2)];
    prePadDims = [shiftedHeight, shiftedWidth];
    paddedImg2 = padImage(img2, prePadDims, postPaddedDimsOf);
    paddedMaskImg2 = padImage(bleedingMask, prePadDims, postPaddedDimsOf);
    
    % show generated padded images and their masks
    images = {paddedImg1, paddedMaskImg1, ...
              paddedImg2, paddedMaskImg2};
    titles = {'padded image 1', 'padded mask image 1', ...
              'padded image 2', 'padded mask image 2'};
    showPaddedImgs(images, titles);
    
    % alpha blend padded images
    compositeMask = (paddedMaskImg1 + paddedMaskImg2);
    
    % avoid NaN issues: max(0,0/0) is 0.
    alpha = max(0, paddedMaskImg1./compositeMask);   
    out = alpha.*paddedImg1 + (1-alpha).*paddedImg2;
    
    disp('panorama stitching process finished');
end

function showPaddedImgs(images, titles)
    N = length(images);
    for k=1:N,
        title_k = char(titles(k));
        image_k = cell2mat(images(k));
        figure('name', title_k)
        imshow(image_k);
    end
end

function showSIFTFrames(images, frames)
    N = length(images);
    figure('name', 'SIFT frames of input images')
    for k=1:N,
        frame_k = cell2mat(frames(k));
        image_k = cell2mat(images(k));
        subplot(1,N,k);
        imshow(image_k);
        hold on;
        vl_plotframe(frame_k, 'color', 'g', 'linewidth', 2);
    end
end

