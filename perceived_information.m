% Input:
% c is the vector with LRA coefficients after training
% x is the values.t. we can split the test set to classes
% leak is the observed leakage of the test set 
% no_bits is the number of bits where we perform LRA
% Output:
% PI is univariate Perceived Information

function PI = perceived_information(c, x, leak, no_bits)

x = bi2de(x);
no_elements = 2^no_bits;


% split test set in classes
class_counter = 0; % class class_counter
testset = cell(no_elements, 1);
for value=0:no_elements-1
    index = find(x==value);
    if ~isempty(index)
        class_counter = class_counter + 1;
        testset{class_counter} = leak(index);    
    end
end

% estimate sigma of leakage using e.g. the 1st class
sigma = std(testset{1});

hs=log2(class_counter);
ps=1/class_counter;

if (class_counter ~= no_elements)
   sprintf('The test set does not have samples of all classes!') 
end


key_bin = de2bi(0:class_counter-1, no_bits);
lin_index = 2 : no_bits + 1;

% check if quadratic terms exist
if size(c, 1) > no_bits + 1
    combination_quadratic = nchoosek(1:no_bits, 2);
    key_bin_quadratic = zeros(class_counter, size(combination_quadratic, 1));
    for i=1:size(combination_quadratic, 1)
        key_bin_quadratic(:, i) = prod(key_bin(:, combination_quadratic(i, :)), 2);
    end
    quad_index = no_bits + 2 : size(c, 1);
end

sum_ext = 0;
for i=1:class_counter
    sum_int = 0;
    chip_term = 1/size(testset{i},1);
    for j=1:size(testset{i}, 1)

        denom = 0;
        for k=1:class_counter
            
            l_prediction1 = c(1) + c(lin_index)' * key_bin(k, :)';
            if size(c, 1) > no_bits + 1
                l_prediction1 = l_prediction1 + ...
                    c(quad_index)' * key_bin_quadratic(k, :)';
            end
            
            difference1 = testset{i}(j,:) - l_prediction1;
            denom = denom + normpdf(difference1, 0, sigma);
        end
        
        l_prediction2 = c(1) + c(lin_index)' * key_bin(i, :)';
        if size(c, 1) > no_bits + 1
                l_prediction2 = l_prediction2 + ...
                    c(quad_index)' * key_bin_quadratic(i, :)';
        end
            
        difference2 = testset{i}(j,:) - l_prediction2;
        num =  normpdf(difference2, 0, sigma);

        model_term = log2(num) - log2(denom);        

        sum_int = sum_int+chip_term * model_term;
    end
    sum_ext = sum_ext + sum_int; 

end

PI=hs+ps*sum_ext;

end




