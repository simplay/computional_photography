function makeMorphingVideo( source, target, frameCount )
%MAKEMORPHINGVIDEO Summary of this function goes here
%   Detailed explanation goes here
% properties
fileName = 'morph1';
matFile = strcat('data/p5/',fileName,'.mat');
videoFile = strcat('outputs/p5/',fileName,'.avi');
videoDuration = 2;
selectNewPoints = false;
timestepFn = @(t) t;


% Start Control Point Selection tool with images and control points 
% stored in variables in the workspace.
[M,N,~] = size(source);

if exist(matFile,'file') && ~selectNewPoints
    load(matFile)
else
    % (x,y) points i.e. (column-idx,row-idx)
    sourcePoints = [1,1; N,1; 1,M; N,M];
    targetPoints = [1,1; N,1; 1,M; N,M];

    % Ask cpselect to wait for you to pick some more points
    
    % If set to FALSE (the default) you can
    % run cpselect at the same time as you run other 
    % programs in MATLAB.
    [sourcePoints, targetPoints] = cpselect(source, target, ...
                                            sourcePoints, targetPoints, ...
                                            'Wait', true);
    % save points
    save(matFile,'sourcePoints','targetPoints');
    
    
    
end

% x values used in order to compute the timesteps t
xs = linspace(0, 1, frameCount);
morphedFrames = zeros(M,N,3,frameCount);
morphedFrames(:,:,:,1) = source;
morphedFrames(:,:,:,frameCount) = target;
parfor k = 2:frameCount-1,
    t = timestepFn(xs(k));
    morphedFrames(:,:,:,k) = morph(source, target, sourcePoints, targetPoints, t);
    disp(['frame number ',num2str(k), ' computed']);
end

%%
% create video file from a series of frames.
    fps = frameCount/videoDuration;
    vidObj = VideoWriter(videoFile);
    vidObj.FrameRate = fps;
    open(vidObj);
    for k = 1:frameCount
        frame = im2double(morphedFrames(:,:,:,k));
        frame = frame - min(frame(:));
        frame = frame ./ max(frame(:));
        frame = im2frame(frame);
        writeVideo(vidObj,frame);
    end
    close(vidObj);
    disp('a new moview has been created and is stored at /outputs/p5/');
end

