function [ieee754_representation] = floatToIEEE754(float_number)
    % Check if the input is a valid floating-point number
    if ~isfloat(float_number)
        error('Input must be a floating-point number');
    end
    % Get the binary representation of the input number
    binary_representation = dec2bin(typecast(single(float_number), 'uint32'), 32);
    % Extract the sign bit, exponent, and mantissa
    sign_bit = binary_representation(1);
    exponent = binary_representation(2:9);
    mantissa = binary_representation(10:end);
ieee754_representation=[sign_bit, exponent, mantissa];
%logical_bits = logical(ieee754_representation - '0');
    % Display the components
    % fprintf('Sign Bit: %s\n', sign_bit);
    % fprintf('Exponent: %s\n', exponent);
    % fprintf('Mantissa: %s\n', mantissa);
    % Construct the IEEE 754 representation
    %ieee754_representation = sprintf('%s %s %s', sign_bit, exponent, mantissa);
end