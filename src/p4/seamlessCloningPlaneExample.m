function seamlessCloningPlaneExample
%FAILINGEXAMPLE4SEAMLESSCLONING Summary of this function goes here
%   Detailed explanation goes here

    baseX=50;
    baseY=550;

    source = imread('imgs/airplane.jpg');
    source = im2double(source);
    source = imresize(source, 0.1);
    m = size(source,1); n = size(source,2);

    target = imread('imgs/landsacpe.jpg');
    target = im2double(target);

    M = size(target,1); N = size(target,2);

    % image mask
    delta=4;
    mask = ones(M,N);
    mask((baseX+1+delta):(baseX+m-delta), ...
         (baseY+1+delta):(baseY+n-delta)) = 0;
    mask = mat2Img(mask(:,:),mask(:,:),mask(:,:));
    
    % zero-pad source image. Keep source in S at position where mask is
    % selecting.
    S = ones(M,1600,3);
    S((baseX+1):(baseX+m), (baseY+1):(baseY+n),:) = source(:,:,:);

    
    out = seamlessCloning(target, S, mask);
    figure('name', 'Seamless Cloning')
    imshow(out)

end

