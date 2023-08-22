function DWstat = DurbinWatson(Y, Y_pred)
    // Durbin-Watson statistic
    //
    // Syntax
    //   DWstat = DurbinWatson(Y, Y_pred)
    //
    // Parameters
    // Y: column of values, data that was fitted
    // Y_pred: column of predicted values
    // DWStat: Durbin-Watson statistic
    
    ES = Y-Y_pred;                  // errors
    SES = sum(ES.^2);                    // sum of errors squared
    SOD = sum((ES(2:$)-ES(1:$-1)).^2);   // sum of differences squared    
    DWstat = SOD/SES;
endfunction
