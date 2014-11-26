function paddedImg = padImage(img, prePadDims, postPaddedDimsOf)
% PADIMAGE Fit dimensionality of panorama images that are supposed to be
% stiched. Zeros pads a given image in the direction 'pre' and then 'post'. 
    % @param img image to zero pad
    % @param prePadDims image dimensions for pre zero padding
    % @param postPaddedDimsOf function handler that helps determining post
    %        zero padding dimensions for given image.
    % @return a zeros padded 3-channel double image that has 
    % 'a' prepended rows and 'b' prepended columns
    % 'c' appended rows and 'd' prepended columns
    % where ['a', 'b'] = [prePadDims(1), prePadDims(2)]
    % and ['c', 'd'] =
    %   [postPaddedDimsOf(paddedImg)(1), postPaddedDimsOf(paddedImg)(2)]

    % Pad before the first array element along each dimension .
    % Arepend prePadDims(1) zero rows 
    % and prepend prePadDims(2) zero columns
    paddedImg = padarray(img, prePadDims, 0, 'pre');
    
    % Pads after the last array element along each dimension
    % Append postPaddedDimsOf(paddedImg)(1) zero rows 
    % and append postPaddedDimsOf(paddedImg)(2) zero columns
    paddedImg = padarray(paddedImg, postPaddedDimsOf(paddedImg), 0, 'post');
    
    % adjust image dimensions - binary mask should also be an image
    if (length(size(paddedImg)) ~= 3)
        paddedImg = mat2Img(paddedImg, paddedImg, paddedImg);
    end
    
    % enforce type safety: values are of type 'double'.
    paddedImg = im2double(paddedImg);
end