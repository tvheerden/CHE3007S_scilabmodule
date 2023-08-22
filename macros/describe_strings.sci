function describe_strings(sheader, sdata)
    // describe string data, similar to describe, but only relevant features. Considering combining into single function in future
    //
    // Syntax
    //   describe_strings(sheader, sdata)
    //
    // Parameters
    // sheader: row vector of strings, names of columns of sdata matrix
    // sdata: matrix of strings, each column corresponding to an sheader

    if size(sheader)(1) > size(sheader)(2) then
        disp('warning: header is in shape of a column');
        sheader = sheader';
    end

    // Size of the matrix for future calculations
    [n_rows, n_cols] = size(sdata);
    
    // Process for functions that dont have oriented calculations
    // Preallocate arrays
    col = zeros(n_rows, 1);
    n_unique = zeros(1, n_cols);
    not_nans = zeros(1, n_cols);
    
    for i = 1:n_cols
        col = sdata(:, i);
        
        // Unique values per column
        n_unique(i) = size(unique(dR_level),1);
        
        // number of nans
        not_nans(i) = n_rows - sum(ones(col).*(col == 'nan'));
        
        dist = tabul(col);
        [nr_top(i), i_max] = max(dist(2));
        top(i) = dist(1)(i_max)
    end

    // Combine data and provide labels for calculated fields
    all_data = [string(not_nans); string(n_unique); string(top); string(nr_top)];
    labels = ['count', 'unique', 'top', 'top freq'];
    
    // Calculate most number of decimal points in numbers
    n_digits = max(length(string(all_data)));
    n_letters = max([length(sheader), length(top)]);
    
    // Get format for mprintf statement based on size of headers/numbers
    n_space = max([n_digits, n_letters]);
    n_space = ceil(n_space/5)*5+1; // Round to nearest 5 and add space
    hformat = sprintf('%%-%is', n_space);
    fformat = sprintf('%%-%i.2f', n_space);
    
    // Print the header formatted
    mprintf('\nTable Description (%i rows)\n', n_rows);
    mprintf(hformat,[""; sheader']);
    mprintf('\n');
    
    // Print data and label for calculation
    for i = 1:size(labels, 2)
        // All rows are integers except 3 (string)
        if i == 3 then
            fformat = sprintf('%%-%is', n_space);
            mprintf(hformat, labels(i));
            mprintf(fformat, top');
            mprintf('\n');
        else
            fformat = sprintf('%%-%ii', n_space);
            mprintf(hformat, labels(i));
            mprintf(hformat, all_data(i, :)');
            mprintf('\n');
        end
    end
    
endfunction
