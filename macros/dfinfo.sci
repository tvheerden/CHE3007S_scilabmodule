function dfinfo(header, data, varargin)
    // Function that displays the name of each column and the nr of non-null entries in that column
    //
    // Syntax
    //   dfinfo(header, data)
    //   dfinfo(header, data, sheader, sdata)
    
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // sheader: k x 1 vector of headers for string data matrix
    // sdata: n x k matrix of string data, matrix of column vectors
    
    if size(header)(1) > size(header)(2) then
        disp('warning: header is in shape of a column');
        header = header';
    end
    
    [lhs, rhs] = argn();
    
    // Size of the matrix for future calculations
    [n_rows, n_cols] = size(data);
    not_nans = zeros(1, n_cols);
    
    for i = 1:n_cols
        col = data(:, i);
        // number of nans
        not_nans(i) = n_rows - sum(isnan(col));
    end
    
    i = [1:n_cols]';
    n_letters = max(length(header));
    hformat = sprintf('%%-%is\t', n_letters);
    printf('\n\nData Columns (total %i columns):\n', n_cols)
    printf('#\t'+hformat+hformat+'\n', 'Column', 'Non-null count')
    printf('%i\t'+hformat+hformat+'\n', i, header', string(not_nans'))

    if rhs == 3 | rhs > 4 then
        disp('incorrect nr of input arguments, 2 or 4 expected')
        abort
    elseif rhs == 4 then
        sheader = varargin(1)
        sdata = varargin(2)
        
        // check sheader is a row
        if size(sheader)(1) > size(sheader)(2) then
            disp('warning: sheader is in shape of a column');
            sheader = sheader';
        end
        // Size of the matrix for future calculations
        [n_rows, n_cols] = size(sdata);
        not_empty = zeros(1, n_cols);
        
        for i = 1:n_cols
            col = data(:, i);
            // number of nans
            not_empty(i) = n_rows - sum(emptystr(col)==col);
        end
        
        i = [1:n_cols]';
        printf('\nString Data Columns (total %i columns):\n', n_cols)
        printf('#\t'+hformat+hformat+'\n', 'Column', 'Non-null count')
        printf('%i\t'+hformat+hformat+'\n', i, sheader', string(not_empty'))
    end

endfunction
