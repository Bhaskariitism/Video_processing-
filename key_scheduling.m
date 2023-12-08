clear all;
close all;
clc;
n = 1000;
a  = 3.78;
x0 = 0.01;
x = zeros(1,n);
y = zeros(1,n);
for i = 1:n
    x(i+1)= a*x(i)*(1 - x(i));
    x(i) = x(i + 1);
end
plot(x);