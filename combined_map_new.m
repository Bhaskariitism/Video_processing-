clear all, close all, clc;
alpha = 1.75325;
r = 3.9;
x0 = 0.1;
num_iterations = 100;

n_values = zeros(1, num_iterations);
x_values = zeros(1, num_iterations);
x = x0;
for i = 1:num_iterations
    n_values(i) = i;
    x_values(i) = x;
    x = r*x*(1-x)+ (4 - r)*(sin(pi*x))/4;
end



plot(n_values, x_values, 'b-', 'LineWidth', 2);
title('Logistic Map');
xlabel('Iteration');
ylabel('Population');
grid on;