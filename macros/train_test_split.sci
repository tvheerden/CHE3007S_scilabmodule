function [x_train, x_test, y_train, y_test] = train_test_split(x, y, varargin)
    // Function to split data into subsets, for testing and training data
    //
    // Syntax
    // [x_train, x_test, y_train, y_test] = train_test_split(x, y)
    // [x_train, x_test, y_train, y_test] = train_test_split(x, y, test_size)
    // [x_train, x_test, y_train, y_test] = train_test_split(x, y, test_size, shuffle)
    //
    // Parameters
    // x:   x data to be split
    // y:   y data to be split
    // test_size:   The fraction of data to be split into test data, or number of data points to split into training data. The default value is 0.25.
    // shuffle: A True/False value to shuffle the data or provide it in linear order. %t is the default value
    // x_train: Split training x data
    // x_test:  Split testing x data
    // y_train: Split training y data
    // y_test:  Split testing y data
    
    // Set defaults for function
    test_size = 0.25;
    shuffle = %t;
    if argn(2) == 3
        test_size = varargin(1);
    elseif argn(2) == 4
        test_size = varargin(1);
        shuffle = varargin(2);
    end
    
    // Calculate number of points to sample if a fraction of data is provided
    n_rows = size(x,1);
    if test_size < 1
        test_size = round(n_rows*test_size);
    end
    
    // Sample random indexes from data. Data must be in the format of data going 
    // down the rows
    idxs = [1:n_rows]';
    if shuffle
        // Sample randomly without replacement so theres no duplicates
        rand_idx = grand(1, "prm", (1:n_rows)'); // random permutation
        test_idx = rand_idx(1:test_size); // first n rows of ramdom indexes
        train_idx = rand_idx(test_size+1:$);
    else
        test_idx = 1:test_size;
        train_idx = (test_size+1):n_rows;
    end
    
    // Sample data
    x_test = x(test_idx, :);
    y_test = x(test_idx, :);
    
    // Create mask for non sampled data points
    mask = ones(n_rows, 1);
    mask(test_idx) = 0;
    mask = find(mask);
    
    x_train = x(mask, :);
    y_train = y(mask, :);
endfunction
