%% Combined map
close all, clear all, clc;

% Define parameters
alpha = 1.75325; % Parameter controlling the sine map (adjust as needed)
r = 3.9; % Parameter controlling the logistic map (adjust as needed)
% Number of iterations
num_iterations = 1000;
% Initialize an array to store the logistic map data
logistic_map_data = zeros(1, num_iterations);
% Initialize an array to store the sine map data
sine_map_data = zeros(1, num_iterations);
% Initial condition (between 0 and 1, experiment with different values)
x0 = 0.1;
n_values = [];
x_values = [];
% Iterate the logistic map equation
x = x0;
for i = 1:num_iterations
    n_values(end+1) = i;
    x = r * x * (1 - x);
    logistic_map_data(i) = x;
    x = sin(pi * alpha * x);
    sine_map_data(i) = x;
    
end
x_values=sine_map_data;
% Create a scatter plot
figure;
scatter(n_values, x_values, 5, 'b', 'filled')
xlabel('Iteration (n)')
ylabel('x')
title('Scatter Plot of Logistic Map')