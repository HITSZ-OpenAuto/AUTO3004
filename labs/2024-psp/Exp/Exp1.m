clc; clear; close all;
x = input3; % 输入数据
z = output3; % 输出数据
N = length(z);

% 初始化矩阵
Phi = zeros(N - 2, 3);
Y = z(3:N);

% 构建回归矩阵
for k = 3:N
    Phi(k - 2, :) = [z(k - 1), x(k - 1), x(k - 2)];
end

% 最小二乘估计
theta = (Phi' * Phi) \ (Phi' * Y);

% 提取参数
a1 = theta(1);
b1 = theta(2);
b2 = theta(3);

% 显示结果
fprintf('最小二乘辨识 221 模型参数:\n');
fprintf('a1 = %.4f\n', a1);
fprintf('b1 = %.4f\n', b1);
fprintf('b2 = %.4f\n', b2);
% 假设输入和输出数据向量

% 初始化矩阵
Phi = zeros(N - 4, 7);
Y = z(5:N);

% 构建回归矩阵
for k = 5:N
    Phi(k - 4, :) = [z(k - 1), z(k - 2), z(k - 3), x(k - 1), x(k - 2), x(k - 3), x(k - 4)];
end

% 最小二乘估计
theta = (Phi' * Phi) \ (Phi' * Y);

% 提取参数
a1 = theta(1);
a2 = theta(2);
a3 = theta(3);
b1 = theta(4);
b2 = theta(5);
b3 = theta(6);
b4 = theta(7);

% 显示结果
fprintf('最小二乘辨识 441 模型参数:\n');
fprintf('a1 = %.4f\n', a1);
fprintf('a2 = %.4f\n', a2);
fprintf('a3 = %.4f\n', a3);
fprintf('b1 = %.4f\n', b1);
fprintf('b2 = %.4f\n', b2);
fprintf('b3 = %.4f\n', b3);
fprintf('b4 = %.4f\n', b4);
