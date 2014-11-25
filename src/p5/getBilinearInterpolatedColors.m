function [ out ] = getBilinearInterpolatedColors( img, positions )
%GETBILINEARINTERPOLATEDCOLORS Summary of this function goes here
%   Detailed explanation goes here
    
    [M,N,~] = size(img);
    isValidIntepolationBoundary = @(x0,y0,x1,y1) x0 > 0 && y0 > 0 && x1 <= N && y1 <= M;

    xs = (positions(1,:));
    ys = (positions(2,:));
    
    % compute closest 4 pixels foreach (x,y) in (xy x ys)
    xs0 = floor(xs); xs1 = ceil(xs);
    ys0 = floor(ys); ys1 = ceil(ys);
    
    out = zeros(3, length(xs));
    
    w_x = positions(1,:)-xs0;
    w_y = positions(2,:)-ys0;
    
    for k=1:length(xs)
       x0 = xs0(k); x1 = xs1(k);
       y0 = ys0(k); y1 = ys1(k);
       if isValidIntepolationBoundary(x0,y0,x1,y1)
            cb = reshape(img(y0,x0,:) .* (1-w_x(k)) + img(y0,x1,:) .* w_x(k),size(img,3),1);
            ct = reshape(img(y1,x0,:) .* (1-w_x(k)) + img(y1,x1,:) .* w_x(k),size(img,3),1);    
            
            % interpolate colors vertically
            out(:,k) = cb .* (1-w_y(k)) + ct .* w_y(k);
       end
    end
    
end

