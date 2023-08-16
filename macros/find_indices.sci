function ind = find_indices(header, columns)
    // A function to find the indices of one matrix within another. The results will return the indices within the "header" vector where the values within "columns" were located.
    //
    // Syntax
    // ind = find_indices(header, columns)
    //
    // Parameters
    // header: a string vector of header labels 
    // columns: a vector of column labels to find within the header matrix
    // ind:     indices within the header data where the columns vector was found       
    [sorted, header_ind, column_ind] = intersect(header, columns);
    ind(column_ind) = header_ind;
    endfunction
