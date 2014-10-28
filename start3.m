% Computational Photography Project 1
% Turned in by <Michael Single>
% Legi: 08-917-445

close all
clear all

%% task 1

% a) plot function f(x) = cos(?ox) with ?o = 2?k/N, x ? [0, 16]
% and the sampled version f (n) frequency k = 1, . . . , 16.
% note that ?o denotes the angular frequency.
figure('Position', [100, 100, 1024, 800], 'name','Plots of cos(2pi*k*x/N) Plots');
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

% ===================================================== end of subtask

% 2.b) Indicate the value of ?o and k at which f(x) hits the Nyquist frequency
disp(['N = ', num2str(N), ' thus N+1 = ', num2str(N+1), ' samples are used.']);
disp(['Hence, the sample rate f_s is equal to ', num2str(N), ' samples per time unit.']); 
disp(['Since the  Nyquist frequency f_n is equal to 0.5*f_s']); 
disp(['It follows f_n = ',num2str(N/2),' for N equal to ',num2str(N)]); 
disp(['Since k denotes a frequency we can set k = f_n = ', num2str(N/2), '(i.e. hit k hits Nyquist frequency)']);
disp(['Then omega = 2*pi*k/N = 2*pi*(N/2)/N = pi']);
disp('');

% ===================================================== end of subtask

%% task 2

% f_n are the samples of the input function
% F_m are the Fourier coefficients
% Let n,m in {0...M?1}, then for a fixed M
% a) create an M ? M matrix for the DFT containing the entries of a DFT

% F_m = \sum_{n=0}^{M-1} f_n e^{ \frac{-i 2\pi m*n}{M} }
% this is equivalent to F_m = *f_n

% predefined
M = 10;

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

% sanity check is loop W equal to loopless W?
deltaW = (W - W_loop);
if(abs(sum(deltaW(:))) < 1E-12)
    disp('W is okay')
else 
    disp('Error: W does not correspond to its loop version!')
end

% ===================================================== end of subtask

% b) check det(U), U*U' = eye(M) = U'*U
disp('Let U := W/sqrt(M)')
U = (W / sqrt(M));

% due to numerical precisson we have to check 
% whether |U*U' - I| < eps |U'*U - I| < eps |det(U) - 1| < eps
eps = 1E-12;

% condition |det(U)| = 1
cond1 = abs(abs(det(U))-1) < eps;

% conditions U*U = UU* = I.
cond2 = abs(sum(sum(U*U'-eye(M)))) < eps;
cond3 = abs(sum(sum(U'*U-eye(M)))) < eps;

% in matlab comparison yielding true corresponds to be equal 1.
% since we have three conditions to check, all are true if their sum is 3.
if( cond1 + cond2 + cond3 == 3 )
    disp('|det(U)| = 1 and U*U = UU* = I holds true');
else
    disp('Error: At least one condition, |det(U)| = 1 and U*U = UU* = I, does not true');
end

% ===================================================== end of subtask

% c)
% Plot elements in DFT matrix
figure('Position', [100, 100, 1024, 800], 'name', 'foobar');

% A the k-th row in M corresponds to coefficients 
% necessary in order to calculate F_k: F_k = M(k,;)*f_n
% Plot rows in W, i.e. coefficients F_k wise.
for m=0:M-1
    subplot(M,2,2*(m+1)-1);
    plot(0:M-1, real(W(m+1,:)), 'r', 0:M-1, imag(W(m+1,:)), 'b');
    if(m==0)
        title('Rows in DFT matrix, real (red) and imaginary (blue) (i-th figure are coeff of Fi)');
    end
end

% Plotting varying (sin, cos)(kx) for varying freq. values k. in range [0,M-1]
for k=0:M-1
    subplot(M,2,2*(k+1));
    fplot(@(x)sin(k*x), [0,M-1], 'r');
    hold on;
    fplot(@(x)cos(k*x), [0,M-1], 'b');
    if(k==0)
        title('sin (red) and cos (blue) for varying frequency values k (i-th figure is k=i)');
    end
end
disp('My Observations:');
disp('Elements in W are equal to e^(-i*2*pi*k/M) = cos(-2*pi*k/M) + i*sin(-2*pi*k/M) (Euler Fromula)'); 
disp('real(e^(-i*2*pi*k/M)) = cos(2*pi*k) (cos is even function');
disp('imag(e^(-i*2*pi*k/M)) = -sin(2*pi*k/M) (sin is odd function');
disp('Until Index M/2 + 1 (assuming M is even) the follwoing holds true:');
disp('See first M/2 + 1 rows in first column in subfigure plots');
disp('Therefore plotting real(e^(-i*2*pi*k/M) gives us a cosine wave with period k');
disp('and plotting imag(e^(-i*2*pi*k/M) gives us a sine wave with period k');
disp('Index m=M/2 has imag = 0');
disp('The periods descrease symmetrically like they increased from this index on.');
disp('In addition, since the real part is a cos wave which is an even function');
disp('the plot of the k-th index is the same as (M/2 - k + 1)-th index (assuming M is even)');
disp('Similarly, the can reason for sine, but it is flipped since sine is an even function');
disp('i.e. sine at k-th plot corresponds to same plot times -1 of (M/2 - k + 1)-th');
disp('To make this observation clear');
disp('Set M=10 in this task and we assume that the first figure is labeled by index 1');
disp('Comparing 3rd figure in column 1 with the 9th figure in column 1, we see that ');
disp('their red curves are the same and that the blue curve of the 3rd one is -1 times the 9th one');
disp('furthermore both have a period equal to 2');

% ===================================================== end of subtask

%d)



