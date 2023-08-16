function [outputs] = group_by(header, data, sheader, sdata, target_column, fun_name)
    // A function to perform a group by operation. This function groups data according to the unique values in the target column of the data, splits the data according to those groups and applies a function to the split data.
    //
    // Syntax
    // [outputs] = group_by(header, data, sheader, sdata, target_column, fun_name)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // sheader: p x 1 matrix of corresponding headers for string/text data
    // sdata:   n x p matrix of string/text data with data as column vectors
    // target_column: Column on which to group the data and calculate the relevant statistics
    // fun_name: function by which to aggregate the data, the options are "mean", "sum", "min", "max", "stdev" and "count"
    // output: structure containing grouped data for each matrix column, and the corresponding headers and unique groups.
    //
    // Description
    // If the data is provided in an n x m matrix, and the group volumn has p unique groups. The output of this function contains the result of applying the desired function to the split groups.
    // A structure with the following fields is returned:
    // <itemizedlist>
    // <listitem><para>data: The result of applying the function to the grouped data, a p x m matrix</para></listitem>
    // <listitem><para>header: The header data for the data, a 1 x m matrix</para></listitem>
    // <listitem><para>rows: The unique groups which the data was split into and aggregated, a 1 x p matrix</para></listitem>
    // <listitem><para>group: a structure with fields of the unique groups, each containing a row vector of data corresponding to the header data</para></listitem>
    // </itemizedlist>
    //
    
    // Initialize group and define available functions
    // New functions can be provided, as long as they accept 'r','c' inputs
    // Wrapper functions can be made to accept 'r','c' and loop through the array
    
    grp = struct(); // Structure for storing grouped data
    group_data = [];
    
    // Functions structure, replace with nan toolbox functions
    functions = struct();
    functions("mean") = mean;
    functions("sum") = sum;
    functions("min") = min;
    functions("max") = max;
    functions("stdev") = stdev;
    functions('count')= size;
    
    // Check which data to split on
    if or(target_column==sheader) then
        condition_data = sdata;
        column_index = sheader==target_column;
        other_columns = header ~= target_column;
    elseif or(target_column==header)
        condition_data = data;
        column_index = header==target_column;
        other_columns = header ~= target_column;
    else
        error('Target column not found in header data')
    end
    
    fun = functions(fun_name);
    unique_rows = unique(condition_data(:, column_index));
    for i = 1:max(size(unique_rows))
        row_name = unique_rows(i); 
        condition = condition_data(:, column_index) == row_name;
        
        grp(string(row_name)) = fun(data(:, other_columns), 'r');
        group_data(i, :)=fun(data(condition, other_columns), 'r');
    end
    group_header = header(other_columns);
    
    outputs = struct();
    outputs('data')=group_data;
    outputs('header')=group_header;
    outputs('rows')=unique_rows;
    outputs('group')=grp;
endfunction
