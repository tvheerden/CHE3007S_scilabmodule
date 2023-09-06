function y_pred = knn_regress(x, y, varargin)
    // Function to determine k nearest neighbors
    //
    // Syntax
    //   y_pred = knn_regress(x, y)
    //   y_pred = knn_regress(x, y, k)
    //
    // Parameters
    // x: n x m matrix of input parameters, each column represents a different parameter
    // y: n x p matrix of target values, each column represents a different variable
    // y_pred: n x p matrix of predicted target values.
    // k: integer describing number of nearest neighbors, default = 5
    
    k = 5
    [lhs, rhs] = argn()

    if rhs > 2 then
        k = varargin(1)
    end

    n = size(x, 1);
    y_pred = zeros(1, n);
   for i = 1:n
        distances = sqrt(sum((x([1:i-1, i+1:n],:) - repmat(x(i, :), n-1, 1)).^2, 2));
        [B, indices] = gsort(distances, 'g', 'i');
        k_indices = indices(1:k);
        weights = (1)./B(1:k);
        weights = ones(weights);
        y_pred(i) = sum(weights.*y(k_indices))/sum(weights);
    end
    y_pred = y_pred'
endfunction
