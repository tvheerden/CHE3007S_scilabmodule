function mode_val = mode_value(column)
    // Helper function to calculate the modal value of a single column, returns the first instance encountered of mode value
    
    // Syntax
    //   mode_val = mode_value(column)
    //
    // Parameters
    // mode_val: the modal value
    // column: vector or matrix of values
    
    // Description
    // Function is intended for use with a column of data, but can equally well determine the modal value for a matrix. 

    // First we generate a frequency distriubtion using tabul
    f_dist = tabul(column);
    
    // Then we value with the highest frequency. Column 2 in the tabul result
    [max_val, i_max] = max(f_dist(:,2));
    mode_val = f_dist(i_max, 1); // Only return first value
endfunction
