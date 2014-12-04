function showEPI(lightFieldData, epiImages, selectedLineNrs)
%SHOWEPI Summary of this function goes here
%   Detailed explanation goes here
  
    [N, ~, ~, rowCount] = size(epiImages);
    disp('EPI images legend: x-axis: selected row and y-axis: k-th camera view.');
    disp('x-axis: selected row');
    disp('y-axis: k-th camera view');
    for k = 1:rowCount
        figure('name', 'From left to right: Scanline, EPI, FT EPI');

        subplot(1,3,1);
        imshow(lightFieldData(:,:,:,k));
        hold on;

        scanline = repmat(selectedLineNrs(k), 1, N);
        plot(1:N, scanline, 'r');
        title('Scanline in Image');

        subplot(1,3,2);
        imshow(epiImages(:,:,:,k));
        title('EPI');

        subplot(1,3,3);
        imshow(getLightFieldEPIData(epiImages, k));
        title('Power Spectrum');
    end
end

