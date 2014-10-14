function demoBilateralFilter( img, sigma_s_seq, sigma_r_seq )
%DEMOBILATERALFILTER renders bilateral filterd images, each in a subplot for
%each sigma value combination.
    
    % open new figure and resize it.
    figure_handler = figure;
    set(figure_handler, 'Position', [100, 100, 800, 800]);
    title('Bilateral Filter Demo');
    
    % used for later for loop in order to generate the figures.
    len_sig_s = length(sigma_s_seq);
    len_sig_r = length(sigma_r_seq);
    
    % get all sigma value combinations
    sigma_pairs = arrays2pairs(sigma_s_seq, sigma_r_seq);
    
    hold on
    idx = 1;
    for k_s=1 : len_sig_s,
        for k_r=1 : len_sig_r,
            
            % combunte current bilateral filter img.
            sigmas = sigma_pairs(idx, :);
            img = bilateralFilter(img, sigmas(1), sigmas(2));
            
            % assign idx of subfigure handler
            g = subplot(len_sig_s,len_sig_r, idx); 
            
            % resize subplot image size
            imgScaleF = 2.5;
            xsize = get(g, 'XLim');
            ysize = get(g, 'YLim');
            set(g, 'XLim', imgScaleF*xsize, 'YLim', imgScaleF*ysize); 
            
            % plot subimage into subfigure: 
            % has to be after resizing the figure dims.
            subimage(img);

            % parse label text (used sigma values) for current subfigure. 
            label_text = strcat(' sigma s=',num2str(sigmas(1)), ...
                       ' sigma r=',num2str(sigmas(2)));
            
            % remove coordiante axis for plots
            set(gca,'xtick',[],'ytick',[]);
            
            % set x-axis label and font-size for current figure
            xlabelHandler = get(g,'XLabel');
            set( xlabelHandler, 'FontSize',16, 'String', label_text);
            
            % update global image index
            idx = idx + 1;
        end
    end
    hold off
end

