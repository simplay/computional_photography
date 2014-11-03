function out = seamlessCloning(target, source, mask)
% SEAMLESSCLONING copy-and-pastes the gradient of a source image onto a
% target image using a poisson solver. 
%   @param target color image (3 channels). The gradient fields of the source
%          image are pasted onto this image. Fields, since there are many
%          color channels which form a gradient field.
%   @param source color image (3 channels). This image's gradient fields
%   are pasted onto the target field.
%   @param mask acts as the boundary condition selector. Thus, this image 
%          determines which pixels are copy-pasted onto the target image.
%   @return out image with adjusted gradient field according to
%   description.

    gradField = img2gradfield(source);
    
    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);
    
    figure('Position', [100, 100, 1024, 800], ...
           'name', 'dx (left) and dy (right) of gradient taken from source')
    
    for k=1:3,
        % show subplot of gradient dx for channel k
        g = subplot(3,2, 2*(k-1)+1);
        subimage(reshape(gradField(:,:,1,1), M, N))
        
        fig_title = strcat('dx of color channel'...
                            ,num2str(k));
        
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]);
        
        
        % show subplot of gradient dy for channel k
        g = subplot(3,2, 2*(k-1)+2);
        subimage(reshape(gradField(:,:,2,1), M, N))
        
        fig_title = strcat('dy of color channel'...
                            ,num2str(k));
        
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]);      
    end
    
    tic
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), gradField(:,:,:,k), mask(:,:,k));
    end
    toc
    
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));

end