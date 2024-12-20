clear; clc; close all;

% 参数定义
register_length = 9; % 寄存器长度
M_init = [1, 1, 0, 0, 0, 1, 0, 0, 1]; % 初始寄存器状态
r = 3; % 生成的 M 序列长度是其周期的（r+1）倍
A = 1; % M 序列幅度
T1 = 8.3; T2 = 6.2; K = 120; % 系统参数
delta_t = 1; % 采样间隔

%% 函数定义

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

% 生成白噪声
function noise = generate_white_noise(len, mean, stddev)
    % 通过统计近似抽样法，利用均匀分布随机数生成正态分布随机数

    n = 40; % 生成的(0,1)均匀分布随机数的数量

    % 生成标准正态分布的随机数
    uniform_samples = rand(len, n); % 生成 len 行 n 列的均匀分布随机数
    normal_samples = sum(uniform_samples, 2) - n / 2; % 累加后减去期望 n/2
    normal_samples = normal_samples / sqrt(n / 12); % 归一化，方差为 1
    noise = normal_samples * stddev + mean; % 乘以标准差并加上均值
    noise = noise'; % 转置为行向量
end

% 获取系统响应
function Y = get_system_response(u, T1, T2, K)
    Gs = tf(K, [T1 * T2, T1 + T2, 1]); % 系统传递函数
    tt = 0:length(u) - 1; % 时间向量
    Y = lsim(Gs, u, tt)'; % 计算系统响应并转置为列向量
end

% 估计脉冲响应 g_theoretical、g_estimated、g_error 分别为理论脉冲响应 g0_k、估计脉冲响应 ghat_k、误差值 delta_g_k
function [g_theoretical, g_estimated, g_error] = estimate_impulse_response(u, Y_noise, T1, T2, K, Np, A, delta_t, r)
    % 计算理论脉冲响应
    time = 0:delta_t:(Np - 1) * delta_t;
    g_theoretical = (K / (T1 - T2)) * (exp(-time ./ T1) - exp(-time ./ T2));

    % 计算互相关系数 Rmz_k
    Rmz_k = zeros(1, Np);

    for tch = 1:Np
        SUM = 0;

        for tcl = Np + 1:(r + 1) * Np
            SUM = SUM + u(tcl - tch) * Y_noise(tcl);
        end

        Rmz_k(tch) = SUM / (r * Np);
    end

    % 估计脉冲响应 ghat_k，补偿量 c = -Rmz_k(Np-1)
    g_estimated = Np * (Rmz_k - Rmz_k(Np - 1)) / ((A ^ 2) * (Np + 1) * delta_t);

    % 误差值计算
    g_error = g_theoretical - g_estimated;
end

% 计算估计误差
function sigma_g = calculate_estimation_error(g_theoretical, g_estimated)
    error_sum = sum((g_theoretical - g_estimated) .^ 2);
    square_sum = sum(g_theoretical .^ 2);
    sigma_g = sqrt(error_sum / square_sum); % 均方根误差
end

%% 主程序

u = generate_m_sequence(M_init, r, A); % 生成 M 序列

figure;
plot(u);
title("M 序列作为输入");
xlim([0, length(u)]);
xlabel('时间');
ylabel('幅度');

Np = 2 ^ length(M_init) - 1; % M 序列周期
Num = (r + 1) * Np;

% 生成白噪声
noise = generate_white_noise(length(u), 0, 1); % 均值 0，方差 1

figure;
histogram(noise, 50);
title('高斯白噪声分布');
xlabel('噪声值');
ylabel('频率');

% 获取系统输出
Y = get_system_response(u, T1, T2, K);
Y_noise = Y + noise; % 带有噪声的系统响应

figure;
hold on;
plot(noise, 'g');
plot(Y, 'r');
plot(Y_noise, 'b');
legend(["白噪声", "系统响应", "带噪声的系统响应"]);
title('系统响应及噪声');
xlim([0, length(Y)]);
xlabel('时间');
ylabel('幅度');
hold off;

% 估计脉冲响应
[g_theoretical, g_estimated, g_error] = estimate_impulse_response(u, Y_noise, T1, T2, K, Np, A, delta_t, r);

% 绘制脉冲响应结果
figure;
hold on;
plot(1:Np, g_theoretical, 'r');
plot(1:Np, g_estimated, 'b');
plot(1:Np, g_error);
title("脉冲响应估计结果");
legend(["理论值", "估计值", "误差值"]);
xlim([0, Np]);
hold off;

% 调用计算误差的函数
sigma_g = calculate_estimation_error(g_theoretical, g_estimated);
disp(['脉冲响应估计误差为：', num2str(sigma_g)]);
