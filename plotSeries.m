function out = plotSeries( img, minGamma, maxGamma )
%PLOTSERIES Summary of this function goes here
%   Detailed explanation goes here
    
    for gamma=minGamma:0.5:maxGamma,
        [out, Lin, Lout] = gammaTransformation(img, gamma);
        hold on
        plotGamma(Lin, Lout, gamma);
        hold off
    end

end

