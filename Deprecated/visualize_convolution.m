s = [1 2 1; 0 0 0; -1 -2 -1];
A = zeros(10);
A(3:7,3:7) = ones(5);
H = conv2(A,s);
figure, mesh(H)