function out = seamlessCloning(target, source, mask)
    
    gradField = img2gradfield(source);
    
    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);
    
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), gradField(:,:,:,k), mask);
    end
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));

end