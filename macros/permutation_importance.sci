function [pij, R2] = permutation_importance(x, y, W, varargin)
// Function to determine permutation importance, and optionally plot results. based on R2 value.
//
// Syntax
//   [pij, R2] = permutation_importance(x, y, W, repeats)
//   [pij, R2] = permutation_importance(x, y, W, repeats, sf)
//   [pij, R2] = permutation_importance(x, y, W, repeats, sf, af)
//   [pij, R2] = permutation_importance(x, y, W, repeats, sf, af, fig)
//   [pij, R2] = permutation_importance(x, y, W, repeats, sf, af, fig, labels)
//
// Parameters
// pij: n x 1 vector describing overall variable importance
// R2: m x repeats matrix of resulting R2 values
// x: n x m matrix of input parameters, each column represents a different parameter
// y: n x p matrix of target values, each column represents a different variable
// W: hypermatrix of weights and biases resulting from trained neural network
// repeats: integer value determining how many permutations to execute
// sf: string variable identifing simulation function, default 'ann_FFBP_run' 
// af: matrix of strings describing activation function for each layer incl output, default = ['ann_tansig_activ','ann_purelin_activ']
// fig: boolean variable indicating if plots should be made or suppressed, default %f
// labels: row vector of strings describing the input variables
//
// Description
// Function to investigate permutation variable importance of trained neural network

[lhs, rhs] = argn();
    
repeats = 10;       //default
sf = 'ann_FFBP_run';
af = repmat('ann_tansig_activ',1,size(W)-1);
af($+1) = 'ann_purelin_activ';
fig = %f;
labels = [];

if size(varargin) > 0 then
    repeats = varargin(1); // Overwrite default
        
    // Second optional argumen is simulation function
    if size(varargin) > 1
        sf = varargin(2);
    end
    
    if size(varargin) > 2
        af = varargin(3)
    end   
    
    if size(varargin) > 3
        fig = varargin(4)
    end
    
    if size(varargin) > 4
        labels = varargin(5)
    end
end

y_pred = evstr(sf+'(x'', W, af)');
SSres = sum((y-y_pred').^2);       // residual
R2_og = 1-SSres/SStot;        // statistic

[nr, nc] = size(x)
SStot = sum((y-mean(y)).^2);
    for i = 1:nc
        for j = 1:repeats
            r_x = grand(1, "prm", (1:nr)'); // random permutation
            x_p = x;
            x_p(:,i) = x(r_x,i);
            y_p = evstr(sf+'(x_p'', W, af)'); // output from permutated input
            SSres = sum((y-y_p').^2);       // residual
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
        title('Permutation variable importance for neural network');
        ylabel('Mean accuracy decrease');
        gg = gca()
        gg.x_ticks.labels = labels';
        // update this to include x axis labels
        
    end
    
    pij = R2_og - sum(R2,'r')/repeats;
endfunction
