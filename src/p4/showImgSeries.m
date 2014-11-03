function showImgSeries(figureTitle, imgs, labels)
%SHOWIMGSERIES Summary of this function goes here
%   Detailed explanation goes here
    figure('Position', [100, 100, 1024, 800], ...
           'name', figureTitle)
       
       
       % char(labels(2))
       
    for k=1:size(imgs,4),
        g = subplot(1,size(imgs,4), k);
        subimage(imgs(:,:,:,k))
        fig_title = char(labels(k));
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]); 
    end

end

