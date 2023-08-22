function [a4, g2, G2, z, Z] = kurtosis(x)
    // Kurtosis function
    //
    // Syntax
    //   [a4, g2, G2, z, Z] = kurtosis(x)
    //
    // Parameters
    // a4: kurtosis
    // g2: excess kurtosis
    // G2: sample excess kurtosis
    // z: test statistic
    // Z: sample test statistic 
    
    
    // mk -> the k'th moment mk = (sum[xi-xbar]^k)/n
    // xbar -> sample mean
    // n -> sample size
    xbar = mean(x);
    n = length(x);
    
    if n < 20 then
        mprintf('\n\nWARNING\n\n')
        mprintf('you have n = %i', n)
        mprintf('\n\nkurtosis is only valid for n >= 20\n\ncontinuing anyway\n\n')
    end
    
    m2 = sum((x-xbar)^2)/n;     // variance
    m3 = sum((x-xbar)^3)/n;     // 3rd moment   
    m4 = sum((x-xbar)^4)/n;     // 4th moment

    a4 = m4/m2^2;           // kurtosis
    g2 = a4-3;              // excess kurtosis
    G2 = (n-1)*((n+1)*g2+6)/((n-2)*(n-3));      // sample excess kurtosis
    
    [g1, G1, z, Z] = skewness(x)    // skewness required
    z = [];
    Z = [];
    
    // standard error of skewness
    SES = sqrt((6*n*(n-1)/((n-2)*(n+1)*(n+3))));   
    // standard error of kurtosis 
    SEK = 2*SES*sqrt((n^2-1)/((n-3)*(n+5)))
   
    z = g2/SEK;     // test statistic
    Z = G2/SEK;     // sample test statistic
endfunction
