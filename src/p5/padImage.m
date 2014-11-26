function paddedImg = padImage(img, prePadDims, postPaddedDimsOf)
    % pads image in the direction 'pre' and then 'post'. 
    % @param img image to zero pad
    % @param prePadDims image dimensions for pre zero padding
    % @param postPaddedDimsOf function handler that helps determining post
    %        zero padding dimensions for given image.

    % Pad before the first array element along each dimension .
    paddedImg = padarray(img, prePadDims, 0, 'pre');
    
    % Pads after the last array element along each dimension.
    paddedImg = padarray(paddedImg, postPaddedDimsOf(paddedImg), 0, 'post');
    
    % adjust image dimensions - binary mask should also be an image
    if (length(size(paddedImg)) ~= 3)
        paddedImg = mat2Img(paddedImg, paddedImg, paddedImg);
    end
    
    % enforce type safety: values are of type 'double'.
    paddedImg = im2double(paddedImg);
end