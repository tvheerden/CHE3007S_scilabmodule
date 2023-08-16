function describe(header, data)
    // This function calculates summary statistics per column for the dataset provided 
    //
    // Syntax
    //   describe(header, data)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    //
    // Description
    // This function calculates summary statistics for the dataset provided per column and displays the ouput to the console. The count, unique count, min, max, mean, standard deviation, mode and 25/75th percentiles.
    
    if size(header)(1) > size(header)(2) then
        disp('warning: header is in shape of a column');
        header = header';
    end


    // Size of the matrix for future calculations
    [n_rows, n_cols] = size(data);
    
    // Using these row wise operations of builtin functions is easier
    // and sometimes faster
    mean_val = nanmean(data, 'r');
    stdev_val = nanstdev(data, 'r');
    min_val = min(data, 'r');
    max_val = max(data, 'r');
    
    // Process for functions that dont have oriented calculations
    // Preallocate arrays
    col = zeros(n_rows, 1);
    n_unique = zeros(1, n_cols);
    mode_val = zeros(1, n_cols);
    per_25 = zeros(1, n_cols);
    per_50 = zeros(1, n_cols);
    per_75 = zeros(1, n_cols);
    not_nans = zeros(1, n_cols);
    
    for i = 1:n_cols
        col = data(:, i);
        
        // Unique values per column
        n_unique(i) = length(unique(col));
        
        // Mode per column
        mode_val(i) = mode_value(col);
        
        // Percentile values
        per_25(i) = perctl(col, 25)(1);
        per_50(i) = perctl(col, 50)(1);
        per_75(i) = perctl(col, 75)(1);
        
        // number of nans
        not_nans(i) = n_rows - sum(isnan(col));
    end
    
    // Combine data and provide labels for calculated fields
    all_data = [not_nans; n_unique; mean_val; stdev_val; min_val;...
                per_25; per_50; per_75; max_val; mode_val];
    labels = ['Numeric', 'Unique', 'Mean', 'Std Dev', 'Min', '25%', '50%', '75%', 'Max', 'Mode'];
    
    // Calculate most number of decimal points in numbers
    n_digits = length(string(round(max(max_val))));
    n_letters = max(length(header));
    
    // Get format for mprintf statement based on size of headers/numbers
    n_space = max([n_digits, n_letters]);
    n_space = ceil(n_space/5)*5+1; // Round to nearest 5 and add space
    hformat = sprintf('%%-%is', n_space);
    fformat = sprintf('%%-%i.2f', n_space);
    
    // Print the header formatted
    mprintf('\nTable Description (%i rows)\n', n_rows);
    mprintf(hformat,[""; header']);
    mprintf('\n');
    
    // Print data and label for calculation
    for i = 1:size(labels, 2)
        // First two rows are integers all others floats
        if i <= 2 then
            fformat = sprintf('%%-%ii', n_space);
        else
            fformat = sprintf('%%-%i.2f', n_space);
        end
        
        mprintf(hformat, labels(i));
        mprintf(fformat, all_data(i, :)');
        mprintf('\n');
    end
endfunction
