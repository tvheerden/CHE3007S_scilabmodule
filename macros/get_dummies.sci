function [encoded_header, encoded_data]=get_dummies(column, indicators, prefix)
    // One hot encoding function
    //
    // Syntax
    //   [encoded_header, encoded_data]=get_dummies(column, indicators, prefix)
    //
    // Parameters
    // encoded_header: row matrix of strings, new header variable including indicators with supplied prefix 
    // encoded_data: matrix of values, original column of data appended with one-hot encoded columns

    encoded_header = prefix+indicators;

    for i = 1:size(indicators, '*')
        encoded_data(:,i) = ones(column).*(column==indicators(i));
    end
endfunction
