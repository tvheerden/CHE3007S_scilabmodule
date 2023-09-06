function [outputs] = group_by(header, data, sheader, sdata, group_column, target_column, fun_name)
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
    
    grp = list(); // Structure for storing grouped data
    group_data = [];
    k = 0
    
    // Functions structure, replace with nan toolbox functions
    functions = struct();
    functions("mean") = nanmean;
    functions("sum") = sum;
    functions("min") = min;
    functions("max") = max;
    functions("stdev") = nanstdev;
    functions('count')= size;
    
    fun = functions(fun_name);
    
    // extract target column
    if or(target_column==sheader) then
        target_data = sdata(:,sheader==target_column);
    elseif or(target_column==header)
        target_data = data(:, header==target_column);
    else
        error('Target column not found in header data')
    end
    
    if size(group_column, '*')==1 then
    // single target column
    // Check which data to split on
    if or(group_column==sheader) then
        groupby_data = sdata(:, sheader==group_column);
    elseif or(group_column==header)
        groupby_data = data(:, header==group_column);
    else
        error('Group by column not found in header data')
    end

    unique_rows = unique(groupby_data);
    for i = 1:max(size(unique_rows));
        row_name = unique_rows(i); 
        condition = groupby_data == row_name;
        if target_data(condition, :) ~= [] & ~and(isnan(target_data(condition, :)))
            k = k+1
            grp(k) = target_data(condition);
            grp_label(k) = string(row_name)
        end
        
        result = fun(target_data(condition, :));
                if fun_name == 'count'
                    result = max(result)
                end
        group_data(i, :)=result;
    end

    outputs = struct();
    outputs('data')=group_data;
    outputs('header')=target_column;
    outputs('rows')=unique_rows;
    outputs('groups')=grp;
    outputs('grouplabels') = grp_label;
    
    else
    // two target columns!
    // Check which data to split on - ASSUME HERE BOTH TARGETS ARE SAME TYPE
        if or(group_column(1)==sheader) then
            groupby_data1 = sdata(:, sheader==group_column(1));
        elseif or(group_column(1)==header)
            groupby_data1 = data(:, header==group_column(1));
        else
            error('Group by column 1 not found in header data')
        end
        if or(group_column(2)==sheader) then
            groupby_data2 = sdata(:, sheader==group_column(2));
        elseif or(group_column(2)==header)
            groupby_data2 = data(:, header==group_column(2));
        else
            error('Group by column 2 not found in header data')
        end

        unique_rows1 = unique(groupby_data1);
        unique_rows2 = unique(groupby_data2);
        for i = 1:max(size(unique_rows1))
            row_name1 = unique_rows1(i);
            condition1 = groupby_data1 == row_name1;
            for j = 1:max(size(unique_rows2))
                row_name2 = unique_rows2(j);
                condition2 = groupby_data2 == row_name2;
                conditions = condition1&condition2
                result = fun(target_data(conditions, :));

                if target_data(conditions, :) ~= [] & ~and(isnan(target_data(conditions, :)))
                    k = k+1
                    grp(k) = target_data(conditions, :);
                    grp_label(k) = string(row_name1)+' + ' + string(row_name2)
                end
                
                if fun_name == 'count'
                    result = max(result)
                end
                group_data(i, j)= result;
            end
        end
    outputs = struct();
    outputs('data')=group_data;
    outputs('header')=target_column;
    outputs('groupedby')=group_column;
    outputs('rows')=unique_rows1;
    outputs('columns')=unique_rows2;
    outputs('groups')=grp;
    outputs('grouplabels') = grp_label;
    end
endfunction
