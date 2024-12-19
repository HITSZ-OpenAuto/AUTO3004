% 通过统计近似抽样法，利用均匀分布随机数生成正态分布随机数

% 参数设置
n = 12; % 生成的(0,1)均匀分布随机数的数量
N = 100000; % 生成的白噪声长度

% 生成标准正态分布的随机数
uniform_samples = rand(N, n); % 生成 N 行 n 列的均匀分布随机数
normal_samples = sum(uniform_samples, 2) - n / 2; % 累加后减去期望 n/2
normal_samples = normal_samples / sqrt(n / 12); % 归一化，方差为 1

% 绘制直方图
figure;
histogram(normal_samples, 50, 'Normalization', 'pdf');
title('标准正态分布随机数的直方图');
xlabel('数值');
ylabel('概率密度');
