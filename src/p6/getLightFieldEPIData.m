function [ epiImgFT ] = getLightFieldEPIData( epiImages, idx )
%GETLIGHTFIELDEPIDATA Summary of this function goes here
%   Detailed explanation goes here
    
    epiImgFT = fftshift(fft2(rgb2gray(epiImages(:,:,:,idx))));
    epiImgFT = log(1 + epiImgFT.*conj(epiImgFT));   
    epiImgFT = mat2normalied(epiImgFT);
end

