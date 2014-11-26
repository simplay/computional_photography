function [matchedPointsImg1, matchedPointsImg2] = retrieveMatchedPoints(frames, matches)
    framesImg1 = cell2mat(frames(1));
    framesImg2 = cell2mat(frames(2));
    
    matchedFramesImg1 = framesImg1(:, matches(1,:));
    matchedPointsImg1 = [matchedFramesImg1(1:2,:); ones(1,size(matchedFramesImg1,2))];
    
    matchedFramesImg2 = framesImg2(:, matches(2,:));
    matchedPointsImg2 = [matchedFramesImg2(1:2,:); ones(1,size(matchedFramesImg2,2))];
    
end