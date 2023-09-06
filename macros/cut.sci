function [bin_assigned, bin_assigned_s, bins] = cut(data, varargin)
    // A function to cut data into bins
    //
    // Syntax
    // [bin_assigned, bin_assigned_s, bins] = cut(data, 'nbins', n)
    // [bin_assigned, bin_assigned_s, bins] = cut(data, 'bins', cut_line)
    //
    // Parameters
    // bin_assinged: vector of values indicating which bin the corresponding data point belongs to
    // bin_assigned_s: vector of strings indicating which bin the corresponding data point belongs to
    // bins: vector of strings describing the bins
    // cut_line: vector of values describing the locations of the cuts
    // data: column vector of values to be cut into bins
    // n: integer value, describing the number of bins, if 'nbins' specified
    
    
    if varargin(1) == 'nbins' then
        n = varargin(2);
        cut_line = linspace(min(data), max(data), n+1);
    elseif varargin(1) == 'bins' then
        cut_line = varargin(2);
        n = length(cut_line) - 1;
    else 
        disp('no suitabe input label given for cut function, nbins or bins expected')
        abort
    end
    
    [data_sorted, sort_i] = gsort(data, 'g', 'i');
    
    bins = '[' + string(cut_line(1)) + ', ' + string(cut_line(2)) + ']'
    for i = 2:n
        bins(i) = '(' + string(cut_line(i)) + ', ' + string(cut_line(i+1)) + ']'
    end

    bin_assigned = %nan*(data_sorted)*n
    bin_assigned_s = repmat('none', length(data_sorted), 1)
    for i = flipdim(1:n,2)
        bin_assigned(find(data_sorted <= cut_line(i+1))) = i;
        bin_assigned_s(find(data_sorted <= cut_line(i+1))) = bins(i);
    end
    bin_assigned(sort_i) = bin_assigned
    bin_assigned_s(sort_i) = bin_assigned_s
endfunction
