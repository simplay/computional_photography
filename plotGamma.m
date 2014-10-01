function plotGamma( Lin, Lout, gamma )
%PLOTGAMMA Summary of this function goes here
%   Detailed explanation goes here
    graphColor = rand(1,3);
    plot(Lin(:),Lout(:), '.', 'color', graphColor);
    xlabel('Input Intensitiy');
    ylabel('Output Intensitiy');
    title('foobar')
    set(gcf,'Color',graphColor)
    str = strcat('gamma=', + num2str(gamma));
    legend(str);
end

