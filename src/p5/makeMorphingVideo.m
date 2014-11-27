function makeMorphingVideo( source, target, frameCount, fileName)
%MAKEMORPHINGVIDEO make a moving by composing different sequencial
% assumption: source and target correspond in their dimensionality.
% morphing timestep results.
%   @param source (M x N x 3) morphing start image.
%   @param target (M x N x 3) morphing target image
%   @param frameCount number of frames that should be generated
%          determines the number of time-steps.
%   @param fileName name of final movie and all intermediate (stored)
%          data.
%   @return .avi movie of name fileName having frameCount frames with a
%           duration of 2 seconds. The file is stored in 'results/p5/' by default.

% global properties to produce results.
matFile = strcat('data/p5/',fileName,'.mat');
videoFile = strcat('outputs/p5/',fileName,'.avi');
videoDuration = 3;
selectNewPoints = false;
timestepFn = @(t) t;
%timestepFn = @(t) -0.5*cos(t*pi())+0.5;


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

% show selected features
figure('name', 'Selected Features in Source image.');
imshow(source);
hold on
plot(sourcePoints(:,1), sourcePoints(:,2), 'xr');

figure('name', 'Selected Features in Target image.');
imshow(target);
hold on
plot(targetPoints(:,1), targetPoints(:,2), 'xr');

% delaunay triangulation of selected source and target points
sourceTriangulation = delaunay(sourcePoints(:,1), sourcePoints(:,2));
targetTriangulation = delaunay(targetPoints(:,1), targetPoints(:,2));
    
% show images with Delaunay triangles
figure('name', 'Delaunay triangulation of Source image');
imshow(source);
hold on
triplot(sourceTriangulation, sourcePoints(:,1), sourcePoints(:,2));
    
figure('name', 'Delaunay triangulation of Target image');
imshow(target);
hold on
triplot(targetTriangulation, targetPoints(:,1), targetPoints(:,2));

% x values used in order to compute the timesteps t
xs = linspace(0, 1, frameCount);

% generate morphed frames
morphedFrames = zeros(M,N,3,frameCount);
morphedFrames(:,:,:,1) = source;
morphedFrames(:,:,:,frameCount) = target;
parfor k = 2:frameCount-1,
    t = timestepFn(xs(k));
    morphedFrames(:,:,:,k) = morph(source, target, sourcePoints, targetPoints, t);
    disp(['Computed Frame number ',num2str(k)]);
end
disp(['Generating a ',num2str(videoDuration), ' second(s) movie using ', num2str(frameCount), ' rendered images...']);

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
    disp(['A new movie ''',fileName '.avi'' has been created and is stored in ''/outputs/p5/''']);
end

