yk = [0.3 0.5 -0.2 0.6 0.83];
u1 = [2.1 -2.7 0.8 1.5 -2.1];

Y = [yk(2); yk(3); yk(4); yk(5)];
X = [-yk(1), u1(2), u1(1);
     -yk(2), u1(3), u1(2);
     -yk(3), u1(4), u1(3);
     -yk(4), u1(5), u1(4)];
% 计算参数估计结果 theta_hat = inv(X' * X) * X' * Y
theta_hat = (X' * X) \ (X' * Y);
disp(theta_hat);
