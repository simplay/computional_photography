%% task 1
close all

figure('name','Plots of cos(2pi*k*x/N) Plots');
N = 16;

idx = 1;
for k=1:16
    h = subplot(4,4,idx);
    fplot(@(x) cos((2*pi()*k/N)*x), [0, 16])
    hold on
    stem(cos((2*pi()*k/N)*(1:16)),'fill','-.');
    hold off
    title(strcat('k=',num2str(idx)))
    idx = idx + 1;
end

% 2.b)
disp(['N = ', num2str(N), ' thus N+1 = ', num2str(N+1), ' samples are used.']);
disp(['Hence, the sample rate f_s is equal to ', num2str(N), ' samples per time unit.']); 
disp(['Since the  Nyquist frequency f_n is equal to 0.5*f_s']); 
disp(['It follows f_n = ',num2str(N/2),' for N equal to ',num2str(N)]); 
disp(['Since k denotes a frequency we can set k = f_n = ', num2str(N/2)]);
disp(['Then omega = 2*pi*k/N = 2*pi*(N/2)/N = pi']);


%% list a matrix for all w0 k pairs
