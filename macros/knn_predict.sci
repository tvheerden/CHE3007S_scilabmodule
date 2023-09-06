function [y_pred] = knn_predict(X_train, y_train, X_test, varargin)
    // Function to determine k nearest neighbors
    //
    // Syntax
    //   [y_pred] = knn_predict(X_train, y_train, X_test)
    //   [y_pred] = knn_predict(X_train, y_train, X_test, k)
    //
    // Parameters
    // X_train: n x m matrix of training set input parameters, each column represents a different parameter
    // y_train: n x p matrix of training set target values, each column represents a different variable
    // X_test: h x m matrix of testing set input parameters, each column represents a different parameter
    // y_pred: h x p matrix of predicted target values.
    // k: integer describing number of nearest neighbors, default = 5
    
    k = 5
    [lhs, rhs] = argn()
    if rhs > 3 then
        k = varargin(1)
    end

    n_train = size(X_train, 1);
    n_test = size(X_test, 1);
    y_pred = zeros(1, n_test);
    
    for i = 1:n_test
        distances = sqrt(sum((X_train - repmat(X_test(i, :), n_train, 1)).^2, 2));
        [B, indices] = gsort(distances, 'g', 'i');
        k_indices = indices(1:k);
        y_pred(i) = mean(y_train(k_indices));
    end
    y_pred = y_pred'
endfunction
