function out = rasterize(v, p)
% function out = rasterize(v, p)
% v: 2x3 matrix containing vertices of triangle
% p: 2xn matrix, containing n pixel coordinates to test

% add homogeneous coordinate
p = [p; ones(1, size(p,2))];

% mask storing insided/outside bit for each edge
m = zeros(3,size(p,2));

for i=1:3,
   % matrix to get vector from vertex to pixel
   t = [1 0 -v(1,i); 0 1 -v(2,i)];
   % get edge normal
   e = [v(1,mod(i,3)+1)-v(1,i); v(2,mod(i,3)+1)-v(2,i)];
   n = [-e(2); e(1)];
   % inside test: t*p yields a matrix of vectors from a vertex to each pixel,
   % n'*t*p computes the dot product of the edge normal with these vectors
   m(i,:) = n'*t*p;
end

out = (m(1,:)>0) .* (m(2,:)>0) .* (m(3,:)>0);