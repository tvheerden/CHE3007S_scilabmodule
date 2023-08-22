function [K,P] = normality(data)
    // Test for normality 
    //
    // Syntax
    //   [K,P] = normality(data)
    //
    // Parameters
    // data: matrix of values, each column is a separate variable
    // K: normality
    // P: population p-value

    
    ZG1 = skewness_test(data);
    ZG2 = kurtosis_test(data);
    
    K = ZG1^2 + ZG2^2;  // sample
    P = 1-distfun_chi2cdf(K,2)  // sample
    //For this normality test, the null distribution for very large samples is
    //the chi-squared distribution with two degrees of freedom.
endfunction
