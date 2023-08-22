function [g1, G1, z, Z] = skewness(x)
    // D'Agostino skewness
    //
    // Syntax
    //   [g1, G1, z, Z] = skewness(x)
    //
    // Parameters
    // g1: population skewness
    // G1: sample skewness
    // z: population test statistic
    // Z: sample test statistic
    // x: column vector data to be tested
        
    xbar = mean(x);
    n = length(x);
    m2 = sum((x-xbar)^2)/n;     // variance
    m3 = sum((x-xbar)^3)/n;     // third moment
    
    g1 = m3/m2^(3/2);               // population skewness
    G1 = g1*sqrt((n*(n-1)))/(n-2);  // sample skewness
    
    // standard error of skewness
    SES = sqrt((6*n*(n-1)/((n-2)*(n+1)*(n+3))));    

    z = g1/SES  // test statistic
    Z = G1/SES  // sample test statistic
endfunction
