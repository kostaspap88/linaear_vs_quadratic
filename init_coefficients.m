% generate leakage coefficients to use in subsequent simulations
% ct: constant term
% a: linear terms
% b: quadratic terms
function [ct, a, b] = init_coefficients(no_bits)

max_lin_coeff = 50;
max_constant_term = 5;
% simulate the linear coefficients
a = randi(max_lin_coeff, no_bits, 1);
% simulate the constant term
ct = randi(max_constant_term, 1, 1);

% simulate the quadratic coefficients
combination_quadratic = nchoosek(1:no_bits, 2);
% you can choose to simulate it randomly: uncomment the next 2 lines
% max_nonlin_coeff = 3; 
% b = randi(max_nonlin_coeff, size(combination_quadratic, 1), 1);

% or you can pick some values for the quadratic coefficients
% if you simulate randomly, then comment the next 3 lines
b = zeros(size(combination_quadratic, 1), 1);
b(1) = 5;
b(2) = 1;

end