function labels = plotGamma( Lin, Lout, gamma, otherlabel )
%PLOTGAMMA Summary of this function goes here
%   Detailed explanation goes here
    graphColor = rand(1,3);
    plot(Lin(:),Lout(:), '.', 'color', graphColor);
    xlabel('Input Intensitiy');
    ylabel('Output Intensitiy');
    title('foobar');
    set(gcf,'Color',graphColor);
    str = strcat('gamma=', num2str(gamma), '-');
    labels = [otherlabel, str];
    values = strsplit(labels, '-');
    for k=1:size(values,2),
        pew{k} = values(k);
    end
    % only show last plot legend
    legend(str);
end

