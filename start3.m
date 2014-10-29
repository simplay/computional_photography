% Computational Photography Project 1
% Turned in by <Michael Single>
% Legi: 08-917-445

close all
clear all
clc

% the following variables and handles are globally available

img = imread('imgs/castle_grey.jpg');
img = im2double(img);

% test for squared error below eps 
eps = 1E-12;

% helper function: For normalizing

% log power spectrum log(1+|F|^2)
logPowerSpec = @(Mat)log(1 + Mat.*conj(Mat));

shiftMat2Min = @(Mat) Mat - min(Mat(:));
scaleMatByMax = @(Mat) Mat ./ max(Mat(:));

% map values of a given matrix to range [0,1]
normalizeMat = @(Mat) scaleMatByMax(shiftMat2Min(Mat));

transformBack = @(Mat) ifft2(ifftshift(Mat));
clipImg = @(Mat) abs(Mat(1:size(img,1), 1:size(img, 2)));

% for inverse filtering
clipTransformBack = @(Mat) clipImg(transformBack(Mat));


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
disp(char(10));
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
disp(char(10))
% ===================================================== end of subtask

% b) check det(U), U*U' = eye(M) = U'*U
disp('Let U := W/sqrt(M)')
U = (W / sqrt(M));

% due to numerical precisson we have to check 
% whether |U*U' - I| < eps |U'*U - I| < eps |det(U) - 1| < eps

% condition |det(U)| = 1
cond1 = (abs(det(U))-1)^2 < eps;

% conditions U*U = UU* = I.
cond2 = (sum(sum(U*U'-eye(M))))^2 < eps;
cond3 = (sum(sum(U'*U-eye(M))))^2 < eps;

% in matlab comparison yielding true corresponds to be equal 1.
% since we have three conditions to check, all are true if their sum is 3.
if( cond1 + cond2 + cond3 == 3 )
    disp('|det(U)| = 1 and U*U = UU* = I holds true');
else
    disp('Error: At least one condition, |det(U)| = 1 and U*U = UU* = I, does not true');
end
disp(char(10))

% ===================================================== end of subtask

% c)
% Plot elements in DFT matrix
figure('Position', [100, 100, 1024, 800], 'name', 'real and imag DFT coefficent W plots');

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
disp(char(10))

% ===================================================== end of subtask

%d)
% Take M samples at 2n?/M, n = 0,...,M ?1 of cos(kx) and store them in a vector x.
x = (2*pi()*(0:M-1));
for k=0:M-1,
    disp(['For k=',num2str(k), ':']);
    Fk = W*cos(x)';
    matlabFk = fft(cos(k * x))';
    
    % W*f_m is equal to FFT{f_m}
    % squered error below eps
    dftsAreTheSame = sum(Fk-matlabFk)^2 < eps;
    if(dftsAreTheSame == 1)
        disp('W*f_k is the same as Matlab`s FFT{f_k}')
    else
        display('Eror: W*f_k NOT SAME as Matlab`s FFT{f_k}')
    end
    
    shiftedFk = fftshift(Fk);
    shiftedMatlabFk = fftshift(matlabFk);
    
    shiftedDftsAreTheSame = (sum(shiftedFk-shiftedMatlabFk)^2 < eps);
    if(shiftedDftsAreTheSame == 1)
        disp('shifted W*f_k is the same as Matlab`s shifted FFT{f_k}')
    else
        display('Eror: shifted W*f_k NOT SAME as shifted Matlab`s FFT{f_k}')
    end
    disp(char(10));
end

disp('My Intuition:');
disp('from Matlab`s help page about the fftshift function:');
disp('1. shifts the zero-frequency component to center of spectrum');
disp('I.e. For a vector v, fftshift(v) swaps the left and right halves of v');
disp(char(10));
disp('Fact: The dft of a function is a Periodic Function');
disp('In our case we the dft of the function is a vector v with M elements.');
disp('Appending the 2nd half of this vector to the first half');
disp('which correspond to swapping the left and right halves of v');
disp('this gives us a center symmetric vector looking like this');
disp('[4,3,2,1,2,3] where `1` is the centered zero frequency.');
disp('Before shifting: [1,2,3,4,3,2] we had this periodic function (aft dft)');
disp(char(10));

% In addition the following example
% a random column vector with 9 elements.
%{
randV = 
    0.9857
    0.1528
    0.7248
    0.9652
    0.3301
    0.5656
    0.0009
    0.8532
    0.5268

% its dft transformation
fft(randV) =
   5.1052 + 0.0000i
   0.4556 + 0.3877i
  -0.1761 - 1.0960i
   0.3752 - 0.4166i
   1.2283 + 1.0215i
   1.2283 - 1.0215i
   0.3752 + 0.4166i
  -0.1761 + 1.0960i
   0.4556 - 0.3877i

% its shifted dft transformation:
 fftshift(fft(randV)) =
   1.2283 - 1.0215i
   0.3752 + 0.4166i
  -0.1761 + 1.0960i
   0.4556 - 0.3877i
   5.1052 + 0.0000i
   0.4556 + 0.3877i
  -0.1761 - 1.0960i
   0.3752 - 0.4166i
   1.2283 + 1.0215i
%}

% ===================================================== end of subtask

% e)
disp('For 1D Fourier tranformation when given M elements');
disp('The DFT has an asymptotic complexity of O(M^2)');
disp('The FTT has an asymptotic complexity of O(M*log(M)');
disp('Speedup factor using the FFT algorithm instead computing DFT Matrix:'); 
disp('O([M^2] / [M*log(M)]) which is in O(M/log(M))');
disp('E.g. given an nxn image (monochromatic) => i.e. M = n^2 (serialized image');
disp('using the DFT algorithm has a asym. complexity in O([n^4]');
disp('using the FFT algorithm has a asym. complexity in O([n^2 log(n^2)]');
disp('which is equal to O([2*(n^2) log(n)] = O([(n^2)*log(n)]');
disp('Assuming for the derivation of the FFT algorithm was a regular Divide&Conquer approach applied')
disp('we referre to the logarithm to the basis of 2, when talking about log')
disp('Therefore, if n=400, then');
disp('using the DFT algorithm: about 2.5600e+10 Iterations');
disp('using the FFT algorithm: about 1.3830e+06 Iterations');
disp('This is for this case a speedup about 4 orders of magnitude (1.8510e+04)');
disp(char(10));

% ===================================================== end of subtask


%% task 3

% a) compute 2dim Fourier transform of a grayscale image
img = imread('imgs/castle_grey.jpg');
img = im2double(img);
imgDft2 = fft2(img);

% ===================================================== end of subtask

% b) 
oneChannel = img(:,:,1);
centerFreqSameAsPixelsum = (imgDft2(1,1)-sum(oneChannel(:)))^2 < eps;
if(centerFreqSameAsPixelsum == 1)
    disp('Element (1,1) of the Fourier transform corresponds to the sum over all pixel values.');
else
    disp('Error: Pixel value sum not central frequency (1,1)')
end
disp(char(10));

% ===================================================== end of subtask

% c) Verify Perseval's Theorem.
M = size(img,1)*size(img,2);
persevalsTheoremHoldsTrue = sum(sum(sum(img.^2))...
                                -(1/M)*sum(sum(imgDft2.*conj(imgDft2)))).^2 < eps;
if(sum(persevalsTheoremHoldsTrue) == 1)
    disp('Perseval`s Theorem holds true');
else
    disp('Error: Perseval`s Theorem does NOT hold true')
end
disp(char(10));                    

% ===================================================== end of subtask

% d) Center dft2 of image
centeredDFT = fftshift(imgDft2);

% ===================================================== end of subtask

% e) Visualize power spectrum

% power spectrum S = |F|^2
S = centeredDFT .* conj(centeredDFT);

% logarithmic values in order to reduce the contrast
spectrum = log(1+S);
% normalize spectrum linearly into range [0,1]
spectrum = (spectrum - min(spectrum(:)));
spectrum = spectrum ./ max(spectrum(:));
figure('name', 'Centered and Scaled Power Spectrum of Image');
imshow(spectrum);

% ===================================================== end of subtask

% f) Visualize phase angles

dftPhase = angle(centeredDFT);
dftPhase = dftPhase - min(dftPhase(:));
dftPhase = dftPhase ./ max(dftPhase(:));
figure('name', 'Centered and Scaled phase angles of Image');
imshow(dftPhase);

% ===================================================== end of subtask


%% task 4

% a) 

% Since filtering in the Fourier domain corresponds to circular convolution
% need to zero-pad the image to avoid boundary artifacts
% zero-pad using twice the size of the image itself
dims = size(img);

% apply dft with zero padding
imgDft2 = fft2(img, 2*dims(1), 2*dims(2));

% ===================================================== end of subtask

% b) 

% basic dimensions:
[height, width, ~] = size(imgDft2);
h = (height - 1)/2;
w = (width - 1)/2;
% Normalized Distances
[x,y] = meshgrid(-w:w,-h:h);
D = x.^2 + y.^2;
D = D-min(D(:));
D = D ./ max(D(:));

% Construct Buttworth Highpass filter: highpass = 1 - lowpass 
% assuming (normalization): Is a function of (D0, n).
H_lowpass = @(D0,n) 1./((1+(D/D0)).^(2*n));
H_highpass = @(D0,n) 1 - H_lowpass(D0,n);

% constr

% Define band pass filter: as a function of (W,D0,n)
H_bandass = @(W,D0,n) 1-(1 ./ (1 + ((W.*D)./(D.^2 - D0^2)).^(2*n)));

% ===================================================== end of subtask

% c)
ns = [2, 10]; % n value used in the slides.
D0s = [0.1, 0.2, 0.3];
Ws = [0.05, 0.1, 0.2];

% Superfancy-modular filter-visualization loop 
figure('Position', [100, 100, 1024, 800], 'name','Visualize log Power Spectrum of filters');

figIdx = 1;
for nIdx=1:length(ns),
    for D0Idx=1:length(D0s),
        
        D0 = D0s(D0Idx);
        n = ns(nIdx);
        
        % current lowpass filter
        fig_title = strcat('LowP: D0='...
                            ,num2str(D0), ' n=', num2str(n));       
        normLow = normalizeMat(logPowerSpec(H_lowpass(D0, n)));
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(normLow);
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        
        % current highpass filter
        fig_title = strcat('HiP: D0='...
                            ,num2str(D0), ' n=', num2str(n));                        
        normHigh = normalizeMat(logPowerSpec(H_highpass(D0, n)));
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(normHigh);
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title);
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        % only for bandpass filter
        for WIdx=1:length(Ws),
            W = Ws(WIdx);
            fig_title = strcat('BandP: D0='...
                            ,num2str(D0), ' n=', num2str(n), ' W',num2str(W));       
            normBand = normalizeMat(logPowerSpec(H_bandass(W,D0,n)));
            g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
            subimage(normBand);
            xlabelHandler = get(g,'XLabel');
            set( xlabelHandler, 'String', fig_title);
            set(gca,'xtick',[],'ytick',[]);
            figIdx = figIdx + 1;
        end
    end
end

% some legend related information
disp('Note that in the previous figure all a row corresponds to a certain D0');
disp('The 1st column is the lowpass filter spectrums');
disp('The 2nd column is the highpass filter spectrum');
disp('And the columns 3-5 are the bandpass filter spectrums for varying W');
disp(char(10));
disp(char(10));

disp('My observations:')
disp('The filters in the previous figure are normalized - range from [0,1]')
disp('Therefore, the brighter the higher the weighting value and vice versa')
disp('White corresponds to the weight 1, black to the weight 0');
disp('Low Pass filter: weighting frequencies closer the center more than those further away');
disp('Select the lower frequencies:') 
disp('Filters hight frequencies out (the detail). Thus we get Blurs image');
disp(char(10));
disp('High Pass filter: weights frequencies further away from the center more than those closer to the center');
disp('Filters low frequencies out.')
disp('The closer this filter gets towards zero, the closer its filtered result is to the original input image');
disp(char(10));
disp('the bandpass filter is a disk selecting a certain band spectrum')
disp(char(10));
disp('D0 affects the size of the radius:');
disp('The bigger D0 the bigger the radius gets and vice versa.');
disp('W affects the width of the filter band:');
disp('Increasing W increases the filter band width.');
disp('Loosly speaking it affects the inner radius of the disk');
disp('the bigger W gets, the smaller the inner radius gets');
disp('N Determins the smoothness of the circle border:');
disp('The higher n gets the sharper the transition');
disp('I.e. low value of n => smooth');
disp('I.e. very high value of n => sharp');


% ===================================================== end of subtask

% d)
imgDft2 = imgDft2(:,:,1);
imgDft2 = fftshift(imgDft2);

% showing power spectrum of images.
figure('Position', [100, 100, 1024, 800], 'name','Spectrum of filtered DFT Img');
figIdx = 1;
for nIdx=1:length(ns),
    for D0Idx=1:length(D0s),
        
        D0 = D0s(D0Idx);
        n = ns(nIdx);
        
        % current lowpass filter
        fig_title = strcat('LowP: D0='...
                            ,num2str(D0), ' n=', num2str(n));       
        normLow = normalizeMat(logPowerSpec(imgDft2 .* H_lowpass(D0, n)));
        
        
        
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(normLow);
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        
        % current highpass filter
        fig_title = strcat('HiP: D0='...
                            ,num2str(D0), ' n=', num2str(n));                        
        normHigh = normalizeMat(logPowerSpec(imgDft2.*H_highpass(D0, n)));
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(normHigh);
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title);
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        % only for bandpass filter
        for WIdx=1:length(Ws),
            W = Ws(WIdx);
            fig_title = strcat('BandP: D0='...
                            ,num2str(D0), ' n=', num2str(n), ' W',num2str(W));       
            normBand = normalizeMat(logPowerSpec(imgDft2.*H_bandass(W,D0,n)));
            g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
            subimage(normBand);
            xlabelHandler = get(g,'XLabel');
            set( xlabelHandler, 'String', fig_title);
            set(gca,'xtick',[],'ytick',[]);
            figIdx = figIdx + 1;
        end
    end
end

% recovering images using the filters
figure('Position', [100, 100, 1024, 800], 'name','Filter Imges');
figIdx = 1;
for nIdx=1:length(ns),
    for D0Idx=1:length(D0s),
        
        D0 = D0s(D0Idx);
        n = ns(nIdx);
        
        % current lowpass filter
        fig_title = strcat('LowP: D0='...
                            ,num2str(D0), ' n=', num2str(n));       
        normLow = imgDft2 .* H_lowpass(D0, n);
        
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(clipTransformBack(normLow));
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        
        % current highpass filter
        fig_title = strcat('HiP: D0='...
                            ,num2str(D0), ' n=', num2str(n));                        
        normHigh = imgDft2.*H_highpass(D0, n);
        g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
        subimage(clipTransformBack(normHigh));
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title);
        set(gca,'xtick',[],'ytick',[]);
        figIdx = figIdx + 1;
        
        % only for bandpass filter
        for WIdx=1:length(Ws),
            W = Ws(WIdx);
            fig_title = strcat('BandP: D0='...
                            ,num2str(D0), ' n=', num2str(n), ' W',num2str(W));       
            normBand = imgDft2.*H_bandass(W,D0,n);
            g = subplot(length(ns)*length(D0s),2+length(Ws),figIdx);
            subimage(clipTransformBack(normBand));
            xlabelHandler = get(g,'XLabel');
            set( xlabelHandler, 'String', fig_title);
            set(gca,'xtick',[],'ytick',[]);
            figIdx = figIdx + 1;
        end
    end
end

% ===================================================== end of subtask


%% task 5

% a)
% gaussian 5x5 kernel with sigma=3
gaussianFilter = fspecial('gaussian',5,1);
blurredImg = imfilter(img, gaussianFilter);

% ===================================================== end of subtask

% b) 

noisyBluredImg = imnoise(blurredImg, 'gaussian', 0, 0.05);

% c)
% centered zero-padded-dft of noisy and noisy-blured imgs
dftBluredImg = fftshift(fft2(blurredImg, 2*dims(1), 2*dims(2)));
dftBluredImg = dftBluredImg(:,:,1);
dftNoisyBluredImg = fftshift(fft2(noisyBluredImg, 2*dims(1), 2*dims(2)));
dftNoisyBluredImg = dftNoisyBluredImg(:,:,1);
dftGaussian = fftshift(fft2(gaussianFilter, 2*dims(1), 2*dims(2)));

% Inverse filtering
invFilteredBlurred = dftBluredImg ./ dftGaussian;
invFilteredNoisyBlured = dftNoisyBluredImg ./ dftGaussian;

figure('name', 'Recovered blury image by Inverse Filtering')
imshow(clipTransformBack(invFilteredBlurred))

figure('name', 'Recovered Noisy image by Inverse Filtering')
imshow(clipTransformBack(invFilteredNoisyBlured))

figure('name', 'Recovered Noisy image by Inverse Filtering scaled linearly to [0,1] range')
imshow(normalizeMat(clipTransformBack(invFilteredNoisyBlured)))


disp('Let I be a given image');
disp('H denotes a filter (here a gaussian filter)');
disp('and N denote noise');
disp('Assuming the Degradation Model')
disp('Then G = H*I + N is the noisy image')
disp('Applying inverse filtering to G using H gives us then:')
disp('invI = G/H = I + N/H');
disp('If the elements in H are relatively small')
disp('the ratio N/H will be relatively large')
disp('Thus, assuming - which is the case in our example -')
disp('that the values the elements in H (our gaussian Filter) are very small')
disp('The noisy will then dominate in the recovered image invI')
disp('This can be observed in the figures shown previousely.')
disp('Note that scale the image linearly into the range [0,1] does not help')
disp('This can also be oberved in one of the previous figures.')
disp('In contrary, images without exhibiting any significant noise')
disp('can be rather well recovered relying on the inverse method')
disp(char(10))

% ===================================================== end of subtask

% d)

figure('Position', [100, 100, 1440, 800], 'name', 'Recovered Noisy Image a using Wiener Filter');
SNR = 0:0.1:0.8;
for idx = 1:length(SNR),
    recoveredImg = deconvwnr(noisyBluredImg, gaussianFilter, SNR(idx));
    subplot(3,3,idx);
    imshow(recoveredImg);
    title(['Recovered image using a Wiener Filter with SNR = ', num2str(SNR(idx))]);
end

disp('The following reasoning does hold true for Wiener filters:');
disp('SNR denotes signal to noise ratio, i.e. Sf(u;v) / Sn(u;v)');
disp('IF the SNR is equal to zero then either');
disp('a) Sf(u;v) is zero for all u,v i.e. there is no signal OR');
disp('b) Sn(u;v) is extremly large for all u,v (almost infinity noise)');
disp('Since case a) clearly cannot be true (since we do have a signal)');
disp('i.e. an image != black');
disp('Case be must be true');
disp('Thus, case b) corresponds to the case when we have almost infinite noise (contribution)');
disp('This can be observed in the first subfigure in the previous figure.');
disp('Having almost inf. Noise will make the Wiener Filter formular almost equal zero');
disp('and then only noise will then dominate.');
disp(char(10))

% ===================================================== end of subtask

%% task 6