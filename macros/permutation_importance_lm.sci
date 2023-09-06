function [pij, R2] = permutation_importance_lm(x, y, B, varargin)
// Function to determine permutation importance of knn models, and optionally plot results. based on R2 value.
//
// Syntax
//   [pij, R2] = permutation_importance(x, y, B)
//   [pij, R2] = permutation_importance(x, y, B, repeats)
//   [pij, R2] = permutation_importance(x, y, B, repeats, fig)
//   [pij, R2] = permutation_importance(x, y, B, repeats, fig, labels)
//
// Parameters
// pij: n x 1 vector describing overall variable importance
// R2: m x repeats matrix of resulting R2 values
// x: n x m matrix of input parameters, each column represents a different parameter
// y: n x p matrix of target values, each column represents a different variable
// B: coefficients of linear model
// repeats: integer value determining how many permutations to execute
// fig: boolean variable indicating if plots should be made or suppressed, default %f
// labels: row vector of strings describing the input variables
//
// Description
// Function to investigate permutation variable importance of trained neural network

[lhs, rhs] = argn();

repeats = 10;       //default
fig = %f;
labels = [];

if rhs > 3 then
    repeats = varargin(1);

    if size(varargin) > 1
        fig = varargin(2)
    end
    
    if size(varargin) > 2
        labels = varargin(3)
    end
end

    y_pred = x*B
    SStot = sum((y-mean(y)).^2)
    SSres = sum((y-y_pred).^2);       // residual
    [R2_og, RMSE_og] = R2MSE(y, y_pred); 
    [nr, nc] = size(x)
        
    for i = 1:nc
        for j = 1:repeats
            r_x = grand(1, "prm", (1:nr)'); // random permutation
            x_p = x;
            x_p(:,i) = x(r_x,i);
            y_p = x_p*B
            SSres = sum((y-y_p).^2);       // residual
            [R2(j, i), RMSE] = R2MSE(y, y_p);
        end
    end
    
    R2(:,1) = []
    
    if fig then
        R2_diff = R2_og - R2;
        R2_errbar = stdev(R2_diff,'r')/sqrt(repeats);
        R2_mean = mean(R2_diff,'r');
        
        scf(), clf();
        bar(R2_mean);
        errbar((1:nc-1), R2_mean, R2_errbar, R2_errbar);
        title('Permutation variable importance for linear regression model');
        ylabel('Mean accuracy decrease');
        gg = gca()
        gg.x_ticks.labels = labels';
        // update this to include x axis labels
        
    end
    
    pij = R2_og - sum(R2,'r')/repeats;

endfunction
