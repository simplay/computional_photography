% Computational Photography Project 1
% Turned in by <Michael Single>
% Legi: 08-917-445

close all
clear all

%% task 1

% a) plot function f(x) = cos(?ox) with ?o = 2?k/N, x ? [0, 16]
% and the sampled version f (n) frequency k = 1, . . . , 16.
% note that ?o denotes the angular frequency.
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

% 2.b) Indicate the value of ?o and k at which f(x) hits the Nyquist frequency
disp(['N = ', num2str(N), ' thus N+1 = ', num2str(N+1), ' samples are used.']);
disp(['Hence, the sample rate f_s is equal to ', num2str(N), ' samples per time unit.']); 
disp(['Since the  Nyquist frequency f_n is equal to 0.5*f_s']); 
disp(['It follows f_n = ',num2str(N/2),' for N equal to ',num2str(N)]); 
disp(['Since k denotes a frequency we can set k = f_n = ', num2str(N/2), '(i.e. hit k hits Nyquist frequency)']);
disp(['Then omega = 2*pi*k/N = 2*pi*(N/2)/N = pi']);
disp('');

%% task 2

% f_n are the samples of the input function
% F_m are the Fourier coefficients
% Let n,m in {0...M?1}, then for a fixed M
% a) create an M ? M matrix for the DFT containing the entries of a DFT

% F_m = \sum_{n=0}^{M-1} f_n e^{ \frac{-i 2\pi m*n}{M} }
% this is equivalent to F_m = *f_n

% predefined
M = 4;

W_loop = zeros(M,M);
for m=0:M-1,
    for n=0:M-1,
        W_loop(m+1,n+1) = exp((-1i*2*pi()*m*n)/M);
    end
end

% Note that this could be further simplified:
% According to Euler's Formular exp(i*phi) = cos(phi) + i sin(phi)
% for phi (-2*pi()*m*n)/M) in this case it follows:
% cos(phi) + i sin(phi) = cos(-2*pi()*m*n)/M) + i sin(-2*pi()*m*n)/M)
% = cos(2*pi()*m*n)/M) - i sin(2*pi()*m*n)/M) % since sine is odd, cos even

% task a) without for loops 
% m,n coefficient matrix

% Indices set M as repeated row vector.
IDX = repmat((0:M-1),M, 1);

% m,n coefficient matrix
Cmn = IDX.*IDX';

% phi matrix as described above in Euler's Formula
phi = 2*pi()*Cmn/M;

% Note that we have used sin(-x) = -sin(x)
% This allows us to abstain from the '-' sign in phi's def.
W = cos(phi)-1i*sin(phi);

% b)
