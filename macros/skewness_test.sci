function [Z] = skewness_test(x)
    // Skewness test
    //
    // Syntax
    //  [Z] = skewness_test(x)
    //
    // Parameters
    // Z: sample skewness
    // x: column vector of data
    
    
    b2 = skewness(x);
    n = length(x);
    if n < 8 then
        printf('\n\nWARNING!!!\nskewtest is not valid with less than 8 samples; %i samples\n\n',n);
    end
    
    // Below adapted from scipy stats module skewtest code
    y = b2 * sqrt(((n + 1) * (n + 3)) / (6.0 * (n - 2)));
    beta2 = (3.0 * (n^2 + 27*n - 70) * (n+1) * (n+3) / ((n-2.0) * (n+5) * (n+7) * (n+9)));
    W2 = -1 + sqrt(2 * (beta2 - 1));
    delta = 1 / sqrt(0.5 * log(W2));
    alpha = sqrt(2.0 / (W2 - 1));
    i = find(y==0);
    y(i) = 1;
    Z = delta * log(y / alpha + sqrt((y / alpha)^2 + 1));
endfunction
