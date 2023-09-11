function [pij, R2] = permutation_importance_knn(x, y, varargin)
// Function to determine permutation importance of knn models, and optionally plot results. based on R2 value.
//
// Syntax
//   [pij, R2] = permutation_importance(x, y, k)
//   [pij, R2] = permutation_importance(x, y, k, repeats)
//   [pij, R2] = permutation_importance(x, y, k, repeats, fig)
//   [pij, R2] = permutation_importance(x, y, k, repeats, fig, labels)
//
// Parameters
// pij: n x 1 vector describing overall variable importance
// R2: m x repeats matrix of resulting R2 values
// x: n x m matrix of input parameters, each column represents a different parameter
// y: n x p matrix of target values, each column represents a different variable
// k: integer value, number of nearest neighbors, default = 5
// repeats: integer value determining how many permutations to execute
// fig: boolean variable indicating if plots should be made or suppressed, default %f
// labels: row vector of strings describing the input variables
//
// Description
// Function to investigate permutation variable importance of trained neural network

[lhs, rhs] = argn();

repeats = 10;       //default
K = 5;
fig = %f;
labels = [];

if rhs > 2 then
    K = varargin(1); // Overwrite default
        
    // Second optional argument is repeats
    if size(varargin) > 1
        repeats = varargin(2);
    end
    
    if size(varargin) > 2
        fig = varargin(3)
    end
    
    if size(varargin) > 3
        labels = varargin(4)
    end
end

    y_pred = knn_predict(x, y, x, K)
    SStot = sum((y-mean(y)).^2)
    SSres = sum((y-y_pred).^2);       // residual
    R2_og = 1-SSres/SStot;        // statistic
    [nr, nc] = size(x)
        
    for i = 1:nc
        for j = 1:repeats
            r_x = grand(1, "prm", (1:nr)'); // random permutation
            x_p = x;
            x_p(:,i) = x(r_x,i);
            y_p = knn_predict(x, y, x_p, K)
            SSres = sum((y-y_p).^2);       // residual
            R2(j,i) = 1-SSres/SStot;        // statistic
        end
    end
    
    if fig then
        R2_diff = R2_og - R2;
        R2_errbar = stdev(R2_diff,'r')/sqrt(repeats);
        R2_mean = mean(R2_diff,'r');
        
        scf(), clf();
        bar(R2_mean);
        errbar((1:nc), R2_mean, R2_errbar, R2_errbar);
        title('Permutation variable importance for k-nearest neighbors');
        ylabel('Mean accuracy decrease');
        gg = gca()
        gg.x_ticks.labels = labels';
        // update this to include x axis labels
        
    end
    
    pij = R2_og - sum(R2,'r')/repeats;
endfunction
