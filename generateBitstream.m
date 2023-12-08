function x_values = generateBitstream(alpha, r, num_iterations, x0)
    logistic_map_data = zeros(1, num_iterations);
    sine_map_data = zeros(1, num_iterations);
    n_values = [];
    x_values = [];
    x = x0;
        n_values(end+1) = 1;
        x = r * x * (1 - x);
        logistic_map_data(1) = x;
        x = sin(pi * alpha * x);
        %sine_map_data(i) = x;
        a=floatToIEEE754(x);
    for i = 2:num_iterations
        n_values(end+1) = i;
        x = r * x * (1 - x);
        logistic_map_data(i) = x;
        x = (1 - r)*(sin(pi*x));
        %sine_map_data(i) = x;
        b=floatToIEEE754(x);
        a=[a,b];
    end
    
    x_values = logical(a - '0');
    
end