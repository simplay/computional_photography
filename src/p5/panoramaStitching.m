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
    %showSIFTFrames(images, frames);
    
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
    
    paddedImg1 = reshape(shiftdim(interpolatedColorsImg1, 1),height, width, 3);
    paddedMaskImg1 = reshape(shiftdim(interpolatedColorMaskImg1, 1),height, width, 3);
    
    paddedImg2 = padarray(img2, [shiftedHeight, shiftedWidth],0,'pre');
    paddedImg2 = padarray(paddedImg2,[height-size(paddedImg2,1), width-size(paddedImg2,2)],0,'post');
    paddedImg2 = im2double(paddedImg2);
    
    
    paddedMaskImg2 = padarray(bleedingMask, [shiftedHeight, shiftedWidth],0,'pre');
    paddedMaskImg2 = padarray(paddedMaskImg2,[height-size(paddedMaskImg2,1), width-size(paddedMaskImg2,2)],0,'post');
    paddedMaskImg2 = mat2Img(paddedMaskImg2,paddedMaskImg2,paddedMaskImg2);
    paddedMaskImg2 = im2double(paddedMaskImg2);
    figure('name', 'padded image 1')
    imshow(paddedImg1);
    figure('name', 'padded mask image 1')
    imshow(paddedMaskImg1);
    
    figure('name', 'padded image 2')
    imshow(paddedImg2);
    figure('name', 'padded mask image 2')
    imshow(paddedMaskImg2);
    
    alpha = paddedMaskImg1 ./ (paddedMaskImg1 + paddedMaskImg2);
    disp('foo3')
    
    out = alpha.*paddedImg1 + (1-alpha).*paddedImg2;
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

