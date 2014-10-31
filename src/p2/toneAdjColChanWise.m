function [ out ] = toneAdjColChanWise( baseImg, awesomeImg, scaleF )
%TONEADJCOLCHANWISE Summary of this function goes here
%   Detailed explanation goes here
    %   Detailed explanation goes here
    
    toneAdjustedR = automatedToneAdjustment(baseImg(:,:,1), ...
                                            awesomeImg(:,:,1), scaleF, ...
                                            2, 0.12);
    toneAdjustedG = automatedToneAdjustment(baseImg(:,:,2), ...
                                            awesomeImg(:,:,2), scaleF, ...
                                            2, 0.12);
                                        
    toneAdjustedB = automatedToneAdjustment(baseImg(:,:,3), ...
                                            awesomeImg(:,:,3), scaleF, ...
                                            2, 0.12);   
    % temporary workaround
    out = yuv2rgb(mat2Img(toneAdjustedR, toneAdjustedG, toneAdjustedB));

end

