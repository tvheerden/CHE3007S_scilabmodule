function regression_summary(Y, X, Y_header, X_header)
    // function to display key statistics of linear regression result
    //
    // Syntax
    //   regression_summary(Y, X, Y_header, X_header)
    //
    // Parameters
    // Y: n x 1 vector, the output data we are attempting to fit
    // X: n x m matrix, the input parameters
    // Y_header: string, descriptive label of Y data
    // X_header: 1 x m vector of strings, descriptive labels of input parameters
    
    
    [B,bint,residual,rint,stats,fullstats] = regress(Y, X);
    
    Dep_Variable = Y_header;
    
    [n, p] = size(X);       // notice here p includes constant!

    DOF_r = fullstats.ResidualDof;   // Degrees of freedom - residuals
    DOF_m = fullstats.RegressionDof;    // Model degrees of freedom
    
    R2 = fullstats.R2;
    R2_adj = 1-(1-R2)*(n-1)/(n-p);
    
    F = fullstats.F;        // F statistic
    pF = fullstats.pval;    // prob (F statistic)
    
    LL = fullstats.LogLikelihood;   // log likelihood
    AIC = -2*LL + 2*p                //Akaike Information Criterion
    BIC = -2*LL + log(n)*p           // Bayesian Information Criterion

    SSres = fullstats.ResidualSS;   // residual sum of squares
    SE = fullstats.Bstddev;      // standard error
    t = B./SE;
    p_t = distfun_tcdf(abs(t),DOF_r, %f)*2;
    
    skew = skewness(residual);
    kurt = kurtosis(residual);
    [Omnibus, Prob_Omnibus] = normality(residual)
    
    Y_pred = X*B;                   // predicted Y values
    DWstat = DurbinWatson(Y, Y_pred);       // Durbin-Watson
    JB = n*(skew^2+0.25*(kurt-3)^2)/6;      // Jarque-Bera
    p_JB = 1-distfun_chi2cdf(JB,2)
    CondNo = cond(X);                       // condition nr 

    printf('\n\nOLS regression results\n');
    printf('====================================================\n')
    labels = ['No. of observations:','DF Residuals:', 'DF model:', 'R-squared:', 'Adj. R-squared:', 'F-statistic:', 'Prob (F-statistic):', 'Log-Likelihood:', 'AIC:', 'BIC:', 'Omnibus:', 'Prob (Omnibus):', 'Skew:', 'Kurtosis:', 'Durbin-Watson:', 'Jarque-Bera (JB):', 'Prob (JB):', 'Cond. No.']';
    data = [n, DOF_r, DOF_m, R2, R2_adj, F, pF, LL, AIC, BIC, Omnibus, Prob_Omnibus, skew, kurt, DWstat, JB, p_JB, CondNo]';
    
    // Get format for mprintf statement based on size of headers/numbers
    n_space = max(length(labels));
    n_space = ceil(n_space/5)*5+1; // Round to nearest 5 and add space
    lformat = sprintf('%%%is', n_space);
    
    // Calculate most number of decimal points in numbers
    n_digits = length(string(data));
    
    n_space = max([n_digits; length(Dep_Variable)]);
    n_space = ceil(n_space/5)*5+1; // Round to nearest 5 and add space
    dformat = sprintf('%%%i.4g', n_space);
    dsformat = sprintf('%%%is', n_space);
    
    mprintf(lformat, 'Dep. Variable:');
    mprintf(dsformat, Dep_Variable);
    mprintf('\n');
    
    // Print data and label for calculation
    for i = 1:size(labels, 1)
        // First three rows are integers
        if i > 3 then
            mprintf(lformat, labels(i));
            mprintf(dformat, data(i, :)');
            mprintf('\n');
        else
            diformat = sprintf('%%%ii', n_space);
            mprintf(lformat, labels(i));
            mprintf(diformat, data(i, :)');
            mprintf('\n');
        end
    end

    header = ['coef', 'std err', 't', 'P>|t|', '[0.025', '0.975]'];
    labels = X_header';
    data = [B, SE, t, p_t, bint];

    n_space = max([max(n_digits), max(length(header)), max(length(labels))]);
    n_space = ceil(n_space/4)*4+1; // Round to nearest 5 and add space
    hformat = sprintf('%%-%is', n_space);

    mprintf('\n\n')
    mprintf(hformat,[""; header']);
    mprintf('\n');
    
    // Print data and label for calculation
    for i = 1:size(labels, '*')
        fformat = sprintf('%%-%i.4g', n_space);
        mprintf(hformat, labels(i));
        mprintf(fformat, data(i, :)');
        mprintf('\n');
    end
endfunction
