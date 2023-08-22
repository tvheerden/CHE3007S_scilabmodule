function Z = kurtosis_test(data)
    // Kurtosis statistical test
    //
    // Syntax
    //   Z = kurtosis_test(data)
    //
    // Parameters
    // data: column of values to be evaluated
    // Z: Kurtosis test result
    
    b2 = kurtosis(data);
    n = length(data);
    
    E = 3.0*(n-1) / (n+1);
    varb2 = 24.0*n*(n-2)*(n-3) / ((n+1)*(n+1.)*(n+3)*(n+5));  // [1]_ Eq. 1
    x = (b2-E) / sqrt(varb2);  // [1]_ Eq. 4
    // [1]_ Eq. 2:
    sqrtbeta1 = 6.0*(n*n-5*n+2)/((n+7)*(n+9)) * sqrt((6.0*(n+3)*(n+5)) / (n*(n-2)*(n-3)));
    // [1]_ Eq. 3:
    A = 6.0 + 8.0/sqrtbeta1 * (2.0/sqrtbeta1 + sqrt(1+4.0/(sqrtbeta1^2)));
    term1 = 1 - 2/(9.0*A);
    denom = 1 + x.*sqrt(2/(A-4.0));
    
    if denom == 0 then
        term2 = %nan
    else 
        term2 = sign(denom)*((1-2/A)/abs(denom))^(1/3);
    end
    
    if or(denom == 0) then
        printf("Test statistic not defined in some cases due to division by 0\nReturns nan in that case")
    end
    
    Z = (term1 - term2) / sqrt(2/(9.0*A))  // [1]_ Eq. 5
endfunction
