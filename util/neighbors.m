function [ neighborIndices, neighborValues ] = neighbors( M, i, j)
%NEIGHBORS Summary of this function goes here
%   Detailed explanation goes here
    [m,n] = size(M);
    
    u = i-1; U = i+1; 
    v = j-1; V = j+1;
    
    if(u < 1) u = 1; end
    if(U > m) U = i; end
    if(v < 1) v = 1; end
    if(V > n) V = j; end
    
    vec1 = u:U; vec2 = v:V;
    [p,q] = meshgrid(vec1, vec2);
    
    neighborIndices = [p(:) q(:)]';
    neighborValues = M(u:U, v:V); 
end

