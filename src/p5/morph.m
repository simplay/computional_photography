function out = morph(sourceImg, targetImg, sourceFeaturePositions, targetFeaturesPositions, timestep )
%MORPH Summary of this function goes here
%   @param sourceImg (M x N x 3) color image
%   @param targetImg (M x N x 3) color image
%   @param sourceFeaturePositions triangle indices
%   @param targetFeaturesPositions triangle indices
%   @param timestep
    
    % indices of fragments in source image
    sourceFragmentsIdxs = delaunay(sourceFeaturePositions(:,1),...
                                   sourceFeaturePositions(:,2));
    out = zeros(size(sourceImg,1),size(sourceImg,2),3);
    % foreach fragment: replace this loop by a reshape                        
    for fragIdx = 1:length(sourceFragmentsIdxs)
        % get indices of spanning vertices of fragIdx-th fragment
        fragmentIdxs = sourceFragmentsIdxs(fragIdx,:);
        
        % 1st row: all x coordinates, 2nd row all y coordinates
        % x_source_p1 x_source_p2 x_source_p3
        % y_source_p1 y_source_p2 y_source_p3
        % 1           1           1
        T_source = [sourceFeaturePositions(fragmentIdxs,:)'; ones(1,3)];
        T_target = [targetFeaturesPositions(fragmentIdxs,:)';ones(1,3)];
        
        % interpolated triangle: p_k = (1-t)a_k + t*b_k 
        T_p = (1-timestep)*T_source + timestep*T_target;
        
        T_p_source = T_source/T_p;
        T_p_target = T_target/T_p;
        
        boundingBox = getBoundingBoxAround(T_p);
        
        % refactor this part
        mask = rasterize(T_p(1:2,:),boundingBox);
        Pixels = boundingBox .* repmat(mask,2,1);
        Pixels = reshape(Pixels(Pixels>0),2,sum(mask));
        Pixels(3,:) = ones(1,size(Pixels,2));
        %
        
        pLeft = T_p_source * Pixels;
        pRight = T_p_target * Pixels;
        
        interpolSourceColors = getBilinearInterpolatedColors(sourceImg, pLeft);
        interpolTargetColors = getBilinearInterpolatedColors(targetImg, pRight);
        
        interpolatedColor = (1-timestep)*interpolSourceColors + timestep*interpolTargetColors;
        
        for k=1:size(Pixels,2)
            out(Pixels(2,k),Pixels(1,k),:) = interpolatedColor(:,k);
        end
    end           
end