% Judging whether the leakage is linear or not. Based on the discussion in 
% Connecting and Improving Direct Sum Masking and Inner Product Masking,
% Poussier et al. and using the standard LRA from A Stochastic Model for
% Differential Side Channel Cryptanalysis, by Schindler et al.

% author : kpcrypto.net

clear all;
close all;

% USER INPUT---------------------------------------------------------------
no_traintraces = 100;
no_testtraces = 300;
no_experiments = 8; % number of repeated simulations for averaging
no_trainpoints = 30; % number of traintraces to model with
sigma = 5.2;
no_bits = 4;

% SIMULATION COEFFICIENT SELECTION-----------------------------------------
[ct, a, b] = init_coefficients(no_bits);
no_traintraces_vector = floor(linspace(10, no_traintraces, no_trainpoints));

PI3 = zeros(no_experiments, 1);
PI4 = zeros(no_experiments, 1);
PI3_avg = zeros(no_trainpoints, 1);
PI4_avg = zeros(no_trainpoints, 1);
PI3_std = zeros(no_trainpoints, 1);
PI4_std = zeros(no_trainpoints, 1);

for i1 = 1 : no_trainpoints

no_traintraces = no_traintraces_vector(i1);
    
for i2 = 1 : no_experiments
    
% LEAKAGE SIMULATION-------------------------------------------------------

[L_hw_train, L_linear_train, L_nonlinear_train, x_bin_train, ...
x_bin_quadratic_train] = leakage_simulation(no_traintraces, sigma, ...
no_bits, ct, a, b);
                                    
[L_hw_test, L_linear_test, L_nonlinear_test, x_bin_test, ...
x_bin_quadratic_test] = leakage_simulation(no_testtraces, sigma, ...
no_bits, ct, a, b);


% LRA PROFILING------------------------------------------------------------

% linear model matrix
one_column = ones(no_traintraces, 1);
X = [one_column x_bin_train];

% nonlinear model matrix
XX = [one_column x_bin_train x_bin_quadratic_train];

% HW leakage, profiling with LRA, using only linear coefficients
c1= X\L_hw_train;

% Linear leakage, profiling with LRA, using only linear coefficients
c2 = X\L_linear_train;

% Nonlinear (quadratic) leakage, profiling with LRA, using only linear 
% coefficients
c3 = X\L_nonlinear_train;

% Nonlinear (quadratic) leakage, profiling with LRA, using linear and
% quadratic coefficients
c4 = XX\L_nonlinear_train;


% LINEAR AND QUADRATIC COMPARISION OF PERCEIVED INFORMATION----------------

% compute PI of a nonlinear dataset, using linear coefficients only
PI3(i2) = ...
    perceived_information(c3, x_bin_test, L_nonlinear_test, no_bits);
% compute PI of a nonlinear dataset, using linear & nonlinearcoefficients 
PI4(i2) = ...
    perceived_information(c4, x_bin_test, L_nonlinear_test, no_bits);


end

PI3_avg(i1) = nanmean(PI3);
PI4_avg(i1) = nanmean(PI4);
PI3_std(i1) = nanstd(PI3);
PI4_std(i1) = nanstd(PI4);

end

plot(no_traintraces_vector, PI3_avg);
hold on;
plot(no_traintraces_vector, PI4_avg);
hold off;









