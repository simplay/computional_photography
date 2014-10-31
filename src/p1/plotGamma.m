function labels = plotGamma( Lin, Lout, gamma, otherlabel )
%PLOTGAMMA Summary of this function goes here
%   Detailed explanation goes here
    graphColor = rand(1,3);
    plot(Lin(:),Lout(:), '.', 'color', graphColor);
    xlabel('Input Intensitiy');
    ylabel('Output Intensitiy');
    title('Plots of transformation curves for different gamma values');
    set(gcf,'Color',graphColor);
    

    labels = [otherlabel; gamma];
    % only show last plot legend
    legend(num2str(labels));
end

