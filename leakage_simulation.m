function [L_hw, L_linear, L_nonlinear, x_bin, x_bin_quadratic] = ...
            leakage_simulation(no_traces, sigma, no_bits, ct, a, b) 

no_elements = 2^no_bits;

% common HW leakage simulation
x = randi(no_elements, no_traces, 1) - 1;
x_bin = de2bi(x);
L_hw = hw(x) + normrnd(0, sigma, no_traces, 1);

% linear leakage simulation
lin_part = x_bin * a + ct;
L_linear = lin_part + normrnd(0, sigma, no_traces, 1);


% non-linear leakage simulation, quadratic terms
combination_quadratic = nchoosek(1:no_bits, 2);
x_bin_quadratic = zeros(no_traces, size(combination_quadratic, 1));
for i=1:size(combination_quadratic, 1)
    x_bin_quadratic(:, i) = prod(x_bin(:, combination_quadratic(i, :)), 2);
end

quadratic_part = x_bin_quadratic * b;

full_part = lin_part + quadratic_part;
L_nonlinear = full_part + normrnd(0, sigma, no_traces, 1);


end