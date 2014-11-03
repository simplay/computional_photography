function [ gradField ] = img2gradfield( img )
%IMG2GRADFIELD computes the gradient field for each color channel of an
%image.
%   @param img (m x n) color image (i.e. has 3 color channels)
%   @returns a (m x n x 2 x 3) gradient field tensor.
%            the 1st and 2nd index correspond to the image's
%               dimensionality.
%            the 3rd index is corresponds to the direction (dx, dy) of the
%               gradient field.
%            the 4th index is corresponds to the color-channel.
    
    gradField = zeros(size(img,1), size(img,2), 2, 3);
    for k=1:3
        [dx, dy] = mat2gradfield(img(:,:,k));
        gradField(:,:,1,k) = dx;
        gradField(:,:,2,k) = dy;
    end
    
end

