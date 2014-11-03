function showGradientFieldImgs( gradField, figureText, M, N )
%SHOWGRADIENTFIELDIMGS Summary of this function goes here
%   Detailed explanation goes here

    figure('Position', [100, 100, 1024, 800], ...
           'name', figureText)
    
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

end

