function n_bins = calculate_bins(data, data_split)
    // A function to calculate the number of bins to be used for a subset of a data source, based on the full dataset provided. The bin width is calculated using the Freedman–Diaconis rule.
    //
    // Syntax
    // n_bins = calculate_bins(data, data_split)
    //
    // Parameters
    // data: full column vector for data to be binned
    // data_split: subsection of the data which the number of bins will be calculated for
    // n_bins: number of bins for the data_split value
    
    bin_width = 2*iqr(data)/(length(data)**(1/3));
    n_bins = round((max(data_split)-min(data_split))/bin_width);
endfunction
