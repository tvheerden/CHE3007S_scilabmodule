function [data_out, header_out] = transform_standardization(data, header, variables_of_interest)
    // centering and scaling of data
    //
    // Syntax
    //   [data_out, header_out] = transform_standardization(data, header, variables_of_interest)
    //
    // Parameters
    // data_out: matrix of values, original data matrix with additional columns containing the centered and scaled data, each column corresponding to a header_out entry
    // header_out:  row vector of strings, headings for data_out
    // data: matrix of values, raw input data
    // header: row vector of strings, headings of data matrix
    // variables_of_interest: row vector of strings, identifying the variables for which we will do centering and scaling.
    
    
    standardize_columns = find_indices(header, variables_of_interest);

    standard_means = mean(data(:,standardize_columns),'r');
    standard_stddev = stdev(data(:,standardize_columns),'r',standard_means);
    new_variable_names = variables_of_interest + ' (standardized)';
    header_out = [header new_variable_names];
    
    for i = 1:size(variables_of_interest, '*');
        data(:,$+1) = (data(:,standardize_columns(i))-standard_means(i))/standard_stddev(i);
    end
    data_out = data;
    
endfunction
