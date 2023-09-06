function [R2, RMSE] = R2MSE(Y, Ypred)
    // Function to determine R^2 and RMSE values comparing two equal sized data sets
    // 
    // Syntax
    //  [R2, RMSE] = R2MSE(Y, Ypred)
    //
    // Parameters
    // Y: vector of values
    // Ypred: vector of values, same size as Y, generally the corresponding predicted values from some model
    // R2: coefficient of determination
    // RMSE: Root means square error (standard deviation of residuals)
    
    n = length(Y);
    RSS = sum((Y-Ypred).^2);
    TSS = sum((Y-nanmean(Y)).^2);
    R2 = 1 - RSS/TSS
    RMSE = sqrt(RSS/n)
endfunction
