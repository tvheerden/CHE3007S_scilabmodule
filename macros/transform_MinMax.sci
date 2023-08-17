function [data_out, header_out] = transform_MinMax(data, header, variables_of_interest)
    // min-max scaling of data
    //
    // Syntax
    //   [data_out, header_out] = transform_standardization(data, header, variables_of_interest)
    //
    // Parameters
    // data_out: matrix of values, original data matrix with additional columns containing the scaled data, each column corresponding to a header_out entry
    // header_out:  row vector of strings, headings for data_out
    // data: matrix of values, raw input data
    // header: row vector of strings, headings of data matrix
    // variables_of_interest: row vector of strings, identifying the variables for which we will do min-max scaling.
    
    
    min_max_columns = find_indices(header, variables_of_interest);

    MIN_maxes = min(data(:,min_max_columns),'r');
    min_MAXES = max(data(:,min_max_columns),'r');
    new_variable_names = variables_of_interest + ' (min-max scaled)';
    header_out = [header new_variable_names];
    
    for i = 1:size(variables_of_interest, '*');
        data(:,$+1) = (data(:,min_max_columns(i))-MIN_maxes(i))/(min_MAXES(i)-MIN_maxes(i));
    end
    data_out = data;
    
endfunction
