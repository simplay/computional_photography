function [ maskedOther1, maskedOther2 ] = foobarize( color_channel, transform2x2, medU, medV, colV, mask)
%FOOBARIZE Summary of this function goes here
%   Detailed explanation goes here


    [m,n] = size(color_channel);
    knownCU = colV(1)*color_channel;
    knownCV = colV(2)*color_channel;

    delU = medU-knownCU;
    delV = medV-knownCV;
    
    other2Channels = transform2x2\[delU(:),delV(:)]';
    % mask it for red channel
    %mask = mask';
    serializedMask = mask(:)';
    
    %% this is wrong, just holds true for red.
    %maskedMedCol = [
    %    color_channel(:)'.*serializedMask; 
    %    other2Channels(1,:).*serializedMask;                     
    %    other2Channels(2,:).*serializedMask 
    %                ];
                
    maskedOther1 = other2Channels(1,:).*serializedMask;
    maskedOther2 = other2Channels(2,:).*serializedMask;
       
    %out = reshape(maskedMedCol', m, n, 3);

end

