function out = pointSets2Homography( p, a )
%POINTSETS2HOMOGRAPHY compute (homogenous) homography 
% transformation from source points p to target points a. 
%   @param p (3 x #points) homogenous source points. 
%   @param a (3 x #points) homogenous target points.
%   @return a (3 x 3) homgenous homographic transformation - from p to a.

    % number of points - usually N = 4
    N = length(p);
    
    % use identifiers from slides
    p_x = p(1,:)'; p_y = p(2,:)';
    a_x = a(1,:)'; a_y = a(2,:)';
    
    A = zeros(2*N, 9);
    
    % system of equation from slide 36
    oddRows = [-p_x, -p_y, -ones(N,1), zeros(N,3), a_x.*p_x, a_x.*p_y, a_x];
    evenRows = [zeros(N,3), -p_x, -p_y, -ones(N,1), a_y.*p_x, a_y.*p_y, a_y];
    
    A(1:2:end-1,:) = oddRows;
    A(2:2:end,:) = evenRows;
    
    % retrieve homographic homogenous transformation: slide 38.
    [~,~,V] = svd(A);
    out = reshape(V(:,9),3,3)';
end

