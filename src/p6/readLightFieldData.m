function images = readLightFieldData(lightFieldPath)
%READLIGHTFIELDDATA reads a light field, stored as a series of png images
%into a image tensor. Order of images is flipped.
%   @param lightFieldPath String user specified path to light field data
%          light field data is assumed to be a series of S (M x N) png
%          images.
%   @return an (M x N x 3 x S) tensor containing all light field images.
    
% if path is provided first try to read it

    if nargin > 0
        directory = lightFieldPath;
    else
        directory = uigetdir;
    end
    
    % check whether a directory is specified.
    if ~(directory == 0)
         % get the names of all image files
         searchFor = strcat(directory, '/*.png');
         dirListing = dir(searchFor);
         
         % get number of images
         numFrames = length(dirListing);
         
         % open images and store it in array
         % first image
         % use full path because the folder may not be the active path
         fileName = fullfile(directory, dirListing(1).name);
         sentinelImg = imread(fileName);
         [M, N, C] = size(sentinelImg);
         images = zeros(M,N,C,numFrames);
         
         for k=1:numFrames
             fileName = fullfile(directory, dirListing(k).name);
             img = im2double(imread(fileName));
             idx = numFrames-k+1;
             images(:,:,:,idx) = img;
         end
         
    end    
end

