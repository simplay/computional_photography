function out = plotSeries( img, minGamma, maxGamma )
%PLOTSERIES Summary of this function goes here
%   Detailed explanation goes here
    initLabel = [];
    hFig = figure(1222);

    hold on
    for gamma=minGamma:0.5:maxGamma,
        [out, Lin, Lout] = gammaTransformation(img, gamma);
        
        initLabel = plotGamma(Lin, Lout, gamma, initLabel);
        
    end
    set(hFig, 'Position', [0 0 1000 1000])
    hold off
end

