function [data_filled]=interpolatedfill(data, varargin);
    // Function to interpolate fill %nan values in data matrix
    //
    // Syntax
    //   [data_filled]=forwardfill(data);
    //   [data_filled]=forwardfill(data, int_method);
    //   [data_filled]=forwardfill(data, int_method, ext_method);
    //
    // Parameters
    // data_filled: n x m matrix of numeric data, with matrix of column vectors, where %nan values of input matrix have been backfilled
    // data:        n x m matrix of numeric data, with matrix of column vectors
    // int_method:  string variable identifying the interpolation method, default "linear"
    // ext_method:  string variable identifying the extrapolation method, default "linear"

    // Description
    // The interpolation method can be selected as "linear", "spline" or "nearest".
    // Linear interpolation is recomended for exptrapolation as other methods can product unrealistic results further away from data.
    // The default method for interpolation and extrapolation is "linear"
    
    
    [lhs,rhs]=argn(0);      // check nr of inputs / outputs
    if rhs > 1 then         // optional argument supplied
        if length(varargin) > 1
            int_method = varargin(1)        // interpolation method
            ext_method = varargin(2)        // extrapolation method
        else
            int_method = varargin(1)
            ext_method = 'linear'           // default to linear
        end
    else
        int_method = 'linear'
        ext_method = 'linear'
    end
    
    [nr, nc] = size(data);
    columns = 1:nc;
    rows = [1:nr]';
        for i = columns(or(isnan(data),'r')); 
        // Strip data of nans and create a corresponding matrix of corresponding indexes
        column_stripped = data(~isnan(data(:,i)),i);
        rows_stripped = rows(~isnan(data(:,i)));
        
        // Interpolate on the data without nans, and apply that interpolation 
        // over the full set of the data to fill in the blanks

        data(:,i) = interp1(rows_stripped, column_stripped, rows, int_method, ext_method);
    end
    data_filled = data;
endfunction
