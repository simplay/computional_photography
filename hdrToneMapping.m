function [ out ] = hdrToneMapping(hdrImg, output_range )
    % error tol
    eps = 0.0001;
    
    % get color chans
    R = hdrImg(:,:,1);
    G = hdrImg(:,:,2);
    B = hdrImg(:,:,3);
    
    % compute intensitites
    intensities = (R*20 + G*40 + B)/61;
    intensities = max(intensities, eps);
    
    % weight color values
    r = (R ./ intensities);
    g = (G ./ intensities);
    b = (B ./ intensities);
    
    log_intensities = log(intensities);
    
    % get base and detail using a bilat. filter
    log_base = bfilt(log_intensities, 2, 0.12);
    log_detail = log_intensities - log_base;
    
    % compression factor
    compressionF = log(output_range)/(max(log_base(:))-min(log_base(:)));
    
    log_offset = -max(log_base(:))*compressionF;
    log_output_intensitiy = log_base*compressionF + log_offset+log_detail;
    
    % remap colrs according to compression factor
    R_output = r .* exp(log_output_intensitiy);
    G_output = g .* exp(log_output_intensitiy);
    B_output = b .* exp(log_output_intensitiy);
       
    out = mat2Img(R_output, G_output, B_output );
end

