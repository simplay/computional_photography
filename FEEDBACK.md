# Feedback

## Project 1
### Task 2.4
To plot a curve, you can create a vector of sample points (uniformly distributed between the range) and compute the response of your function for that vector.

## Project 2
Actually the size of the neighborhood in Gaussian-like kernels is infinite! But we pick the window as 1.5xSigma to get good-enough results with less computation. But thanks for the explanations! For the bilateral filter, as we saw, you can take out the distance term out of the loop since its shift invariant and save a lot of time. 

## Project 3
The parseval point is to preserve the signal energy in the compression process, so when we remove the small coeficients, we do not change a lot. Therfore one would remove frquency values that are smaller than some threshold (not necessary high frequencies). This way the high frequencies that are significantly high will be preserved.

## Project 4
The gradient compression AND poisson solving happens in the log domain! 
