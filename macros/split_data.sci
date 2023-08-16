
function [all_y, hues] = split_data(header, data, sheader, sdata, hue, column, varargin)
    // Function to split data into a single 
    //
    // Syntax
    // [all_y, hues] = split_data(header, data, sheader, sdata, hue, column)
    // [all_y, hues] = split_data(header, data, sheader, sdata, hue, column, hue_bin)

    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // sheader: p x 1 matrix of corresponding headers for string/text data
    // sdata:   n x p matrix of string/text data with data as column vectors
    // hue:     label of field on which to split the data into different groups and colours for plotting
    // column:  string label for column or index
    // hue_bin: if hue column is corresponding to a numeric field, this is the the number of bins to split the data into linearly over range, the default for this is 5.
    // all_y:   a list of vectors of the split data points corresponding to the hue values provided
    // hues:    a string vector containg the categories on which the data was split
        
        if type(column)==10 then
            j = find(header == column);
            if length(j) == 0
                error('Column not found in header data')
            end
        else
            j = column;
        end
        
    if length(varargin)==1 then
        hue_bin = vararin(1);
    else
        hue_bin = 5;
    end

    if or(hue == sheader) then
        // If the hue is one of the string values then split
        // the data on the hue
        // Initialize the lists
        all_y = list();

        // Find the unique hue values for splitting the data
        hue_data = sdata(:, hue==sheader);
        hues = unique(hue_data);
        hues(hues=="") = []; // Ignore empty values

        // Split the data on the hues
        for k = 1:size(hues, '*');
            all_y(k) = data(hue_data==hues(k), j);
        end
    elseif or(hue == header)
        // Initialize the lists
        all_y = list();

        hue_data = data(:, hue==header);
        hues = unique(hue_data);

        if length(hues)<5
            // Split the data on the hues
            for k = 1:size(hues, '*');
                all_y(k) = data(hue_data==hues(k), j);
            end
        else
            // If the hue is in the numeric data, split the data into bins
            hues = linspace(min(hue_data), max(hue_data), hue_bin);
            for k = 1:hue_bin;
                if k < hue_bin
                    con = hue_data>hues(k)&hue_data<hues(k+1);
                    all_y(k) = data(con, j);
                else
                    con = hue_data<hues(k)&hue_data>hues(k-1);
                    all_y(k) = data(con, j);
                end
            end
            hues = string(hues(1:$-1));
        end

    else
        error('Hue present not in numeric or string header data')
    end
endfunction
