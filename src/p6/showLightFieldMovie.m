function [ frames ] = showLightFieldMovie( lightFieldData )
%GENERATELIGHTFIELDMOVIE Summary of this function goes here
%   Detailed explanation goes here

    [~,~,~,numFrames] = size(lightFieldData);
    frames = repmat(struct('cdata', 1, 'colormap', 2), numFrames, 1 );
    for k=1:numFrames
        frames(k) = im2frame(lightFieldData(:,:,:,k));
    end
    figure('name', 'Light Field Data Movie');
    imshow(lightFieldData(:,:,:,1));
    movie(frames);

end

