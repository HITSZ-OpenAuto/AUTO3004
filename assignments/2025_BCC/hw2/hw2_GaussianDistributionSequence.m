% 用统计近似抽样法产生服从标准正态分布的离散白噪声

m = 1000;  % 生成的正态白噪声序列长度
N = 1000;  % 每个正态样本由N个均匀随机数组成
mu_eta = 5;    % 目标分布的均值
sigma_eta = 2; % 目标分布的标准差

uniformSequence = rand(N, m)

gaussianSequence = mu_eta + sigma_eta .* (sum(uniformSequence)-N/2) / sqrt(N/12)

% 时域波形
figure;
plot(gaussianSequence);
title('标准正态分布白噪声序列');
xlabel('样本点');
ylabel('幅值');
grid on;

% 概率分布直方图
figure;
histogram(gaussianSequence, 100, 'Normalization', 'pdf');
hold on;
title('白噪声概率密度分布');
xlabel('值');
ylabel('概率密度');
grid on;