%Hamming weight computation function

function hw = hw(matrix)

hw = zeros(size(matrix,1), 1);
for i=1:size(matrix,1)
     hw(i)=sum(dec2bin(matrix(i)) == '1');
end

end