clear; clc; close all;

% 生成 M 序列
function u = generate_m_sequence(M_init, r, A)
    Np = 2 ^ length(M_init) - 1; % M 序列周期
    Num = (r + 1) * Np; % M 序列长度
    u = zeros(1, Num);
    M = M_init;

    for i = 1:Num
        u(i) = M(length(M_init)); % 取出最后一位作为当前输出
        m = xor(M(length(M_init)), M(5)); % 异或生成反馈位
        M = [m M(1:length(M_init) - 1)]; % 移位操作
    end

    u = A * (1 - 2 * u); % 值域为 (-A, A) 的 M 序列
end

register_length = 9;
M_init = [1, 1, 0, 0, 0, 1, 0, 0, 1];
u = generate_m_sequence(M_init, 3, 1);

figure;
plot(u);
title("M 序列作为输入");
xlim([0, length(u)]);
xlabel('时间');
ylabel('幅度');

sigma = 0.2; % 高斯白噪声方差
Nmax = 100; % 计算次数
x = zeros(1, Nmax);
y = zeros(1, Nmax);
z = randn(1, Nmax) * sigma;
theta = zeros(4, Nmax); % 初值设为 0
P = 100 * eye(4);

for i = 3:Nmax
    % 系统差分方程
    x(i) = 1.5 * x(i - 1) -0.7 * x(i - 2) + 1 * u(i - 1) + 0.5 * u(i - 2);
    y(i) = x(i) + z(i);
    % 计算 phi
    phi = [y(i - 1) y(i - 2) u(i - 1) u(i - 2)]';
    % 计算 theta, K 和 P
    K = P * phi / (1 + phi' * P * phi);
    theta(:, i) = theta(:, i - 1) + K * (y(i) - phi' * theta(:, i - 1));
    P = P - P * phi / (1 + phi' * P * phi) * phi' * P;

end

figure;
hold on;
title("输出");
plot(x);
plot(y);
legend("原输出", "带噪声输出");
hold off;
figure;

subplot(1, 2, 1);
hold on;
title("参数估计", "FontSize", 20, "FontWeight", "bold");

for i = 1:4
    plot(1:length(theta(i, :)), theta(i, :));
end

legend("a_1", "a_2", "b_1", "b_2");
hold off;
param = [1.5 -0.7 1 0.5];
subplot(1, 2, 2);

hold on;
title("参数估计误差", "FontSize", 20, "FontWeight", "bold");

for i = 1:4
    error = theta(i, :) - param(i);
    plot(1:length(error), error);
end

legend("a_1", "a_2", "b_1", "b_2");
hold off;
