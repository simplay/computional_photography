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
    u = xs-xs0; v = ys-ys0;
    
    out = zeros(3, length(xs));
    for k=1:length(xs)
       x0 = xs0(k); x1 = xs1(k);
       y0 = ys0(k); y1 = ys1(k);
       if isValidIntepolationBoundary(x0,y0,x1,y1)
            c_b = reshape(img(y0,x0,:).*(1-u(k)) + img(y0,x1,:).*u(k),size(img,3),1);
            c_t = reshape(img(y1,x0,:).*(1-u(k)) + img(y1,x1,:).*u(k),size(img,3),1);    
            out(:,k) = c_b.*(1-v(k)) + c_t.*v(k);
       end
    end
    
end

