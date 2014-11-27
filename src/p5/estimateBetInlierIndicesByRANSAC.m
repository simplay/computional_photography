function inliersIndices = estimateBetInlierIndicesByRANSAC(matches, matchedPointsImg1, matchedPointsImg2)
% find best (estimated inlier) by running 1000 times RANSAC. 
    highestInlierCount = 0;
    inliersIndices = [];
    for i=1:1000,
        % Generate four integer values drawn uniformly from 1 to length(matches)
        % these values are supposed to represent point indices.
        randomIdxs = randi([1,length(matches)],1,4);
        
        random4PointsImg1 = matchedPointsImg1(:, randomIdxs);
        random4PointsImg2 = matchedPointsImg2(:, randomIdxs);
        
        % compute the homographic transformation H from random4PointsImg1 to
        % random4PointsImg2
        H = pointSets2Homography(random4PointsImg1, random4PointsImg2);
        
        interpImg2Points = H*matchedPointsImg1;
        w = interpImg2Points(3,:);
        interpImg2Points = interpImg2Points./repmat(w,3,1);
        
        % calculate euclidian distance between interpolated img2 points (from
        % img1) and actual img2 points from 4 random chosen points.
        % Distances gives a qualitiy how well points were matched.
        pointMachingDistances = sqrt(sum((interpImg2Points-matchedPointsImg2).^2));
        
        % find indices of interpolated points that have an error of at most
        % 1 pixel
        inlierIdxs = find(pointMachingDistances <= 1);
        currentInlierAcceptedCount = length(inlierIdxs);
        
        if currentInlierAcceptedCount > highestInlierCount
            highestInlierCount = currentInlierAcceptedCount;
            inliersIndices = inlierIdxs;
        end
    end
    
end