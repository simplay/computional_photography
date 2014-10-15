function [ out ] = automatedToneAdjustment( input, model, scaleF, sigma_s, sigma_r )
%awesomify given input images refering to a given awesome model image.
%  images which can be considered as rather being boring.
%  model images which is suppoes to be awesome.
%  scaleF enhancement factor, real numbered value.

    % obtain two scale decomposition of the input and model image
    large_scale_input = bfilt(input, sigma_s, sigma_r);
    large_scale_model = bfilt(model, sigma_s, sigma_r);
    
    % transfer the histogram of the large-scale layer of the model to the
    % large-scale layer of the input.
    
    
    hist_lc_model = imhist(large_scale_model);
    
    %J = histeq(I,HGRAM) transforms the intensity image I so that the histogram
    % of the output image J with length(HGRAM) bins approximately matches HGRAM.
    
    J = histeq(large_scale_input, hist_lc_model);
    
    % scale the detail layer of the input by a user adjustable factor.
    
    % obatin the output by summing the histgram matched large scale and
    % scaled detail layer of input.
    
    detail_input = input-large_scale_input;
    out = detail_input*scaleF + J;
end

