clc; clear; close all;

% (1) 使用 step 函数产生该系统的阶跃响应，并在响应曲线中加入不同方差的高斯白噪声
G = tf(1, [6, 12, 3, 1]);
t = 0:0.1:60;
[y, t] = step(G, t);
y_noise1 = y + sqrt(0.001) * randn(size(y));
y_noise2 = y + sqrt(0.002) * randn(size(y));
y_noise3 = y + sqrt(0.005) * randn(size(y));
figure;
subplot(1, 3, 1)
plot(t, y_noise1)
legend("方差=0.001")
subplot(1, 3, 2)
plot(t, y_noise2)
legend("方差=0.002")
subplot(1, 3, 3)
plot(t, y_noise3)
legend("方差=0.005")

% (2) 利用产生的阶跃响应通过面积法辨识得到传递函数中的参数。
G = tf(1, [6 12 3 1]);
t = 0:0.1:60;
y = step(G, t)';
% 定义面积函数，计算 M(i)
function result = M(i)
    t = evalin('base', 't');
    y = evalin('base', 'y');
    % trapz 使用梯形法则进行数值积分
    result = trapz(t, (1 - y) .* (-t) .^ (i - 1) / factorial(i - 1));
end

% 利用 M(i) 计算 A1, A2, A3
A1 = M(1);
A2 = M(2) + A1 * M(1);
A3 = M(3) + A1 * M(2) + A2 * M(1);
fprintf('A1 = %.2f\nA2 = %.2f\nA3 = %.2f\n', A1, A2, A3);
b1 = 1; a1 = A3; a2 = A2; a3 = A1; a4 = 1;
G2 = tf(b1, [a1 a2 a3 a4]);
y2 = step(G2, t);
figure;

plot(t, y', 'b', t, y2, 'r--');
title('阶跃响应曲线');
xlabel('t');
ylabel('阶跃响应');
legend('原响应', '辨识响应');
