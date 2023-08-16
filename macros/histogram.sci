
function histogram(header, data, sheader, sdata, category, column)
    // A function to plot a histogram with data split into different categories
    //
    // Syntax
    // histogram(header, data, sheader, sdata, category, column)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // sheader: p x 1 matrix of corresponding headers for string/text data
    // sdata:   n x p matrix of string/text data with data as column vectors
    // category:     label of field on which to split the data into different groups and colours for plotting
    // column:  string label for column or index
        
    [split_y, hues] = split_data(header, data, sheader, sdata, category, column)
    
    f = gcf();
    for k = 1:length(split_y)
        n_bins = calculate_bins(data(:, column), split_y(k));
        colour = f.color_map(k+1,:)*255;
        histo(split_y(k), n_bins, "FaceColor", colour);
    end
    
    legend(string(hues));
    endfunction
