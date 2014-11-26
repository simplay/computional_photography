function [boundingBox, width, height, shiftedWidth, shiftedHeight] = computeBoundingBoxFromCorners(H,M,N)
    findDimShift = @(base, idx) min(base(idx,:));
    delta = @(base, idx) max(base(idx,:)) - findDimShift(base, idx);
    posCeil = @(base, idx, handle) ceil(abs(handle(base, idx)));

    cornerHomogenousPoints = [arrays2pairs([1,N],[1,M])'; ones(1,4)];
    
    toBestImg2InliersTransformedCorners = H*cornerHomogenousPoints;
    w = toBestImg2InliersTransformedCorners(3,:);
    toBestImg2InliersTransformedCorners = toBestImg2InliersTransformedCorners./repmat(w,3,1);
    
    cornerPoints = [toBestImg2InliersTransformedCorners, cornerHomogenousPoints];
    
    width = posCeil(cornerPoints, 1, delta);
    height = posCeil(cornerPoints, 2, delta);
    
    shiftedWidth = posCeil(cornerPoints, 1, findDimShift);
    shiftedHeight = posCeil(cornerPoints, 2, findDimShift);
    
    [xIdx, yIdx] = meshgrid(1:width, 1:height);
    boundingBox = [xIdx(:)'-shiftedWidth;
                   yIdx(:)'-shiftedHeight
                   ones(1, length(xIdx(:)'))];
end