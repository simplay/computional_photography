%% task 1
close all

figure('name','Plots of cos(2pi*k*x/N) Plots');
N = 16;

idx = 1;
for k=1:16
    hold on
    h = subplot(4,4,idx);
    fplot(@(x) cos((2*pi()*k/N)*x), [0, 16])
    stem(cos((2*pi()*k/N)*(1:16)),'fill','-.');
    hold off
    title(strcat('k=',num2str(idx)))
    idx = idx + 1;
end

