function out = plotSeries( img, minGamma, maxGamma )
%PLOTSERIES Summary of this function goes here
%   Detailed explanation goes here
    initLabel = [];
    hold on
    for gamma=minGamma:0.5:maxGamma,
        [out, Lin, Lout] = gammaTransformation(img, gamma);
        
        initLabel = plotGamma(Lin, Lout, gamma, initLabel);
        
    end
    hold off
end

