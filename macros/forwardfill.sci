
function [data_filled]=forwardfill(data);
    // Function to forwardfill %nan values in data matrix
    //
    // Syntax
    //   [data_filled]=forwardfill(data);
    //
    // Parameters
    // data_filled:  n x m matrix of numeric data, with matrix of column vectors, where %nan values of input matrix have been forwardfilled
    // data:    n x m matrix of numeric data, with matrix of column vectors

    // Description
    // Function to forwardfill %nan values in numeric data marix. For special case where first value is %nan, we use backward filling for this and then forwardfill for rest
    
    [nr, nc] = size(data);
    for i = 1:nc;
        if isnan(data(1,i)) then
            data(1,i) = data(~isnan(data(:,i)),i)(1); // replace with the first non-nan nr
        end
        
        // for all nan entries in reverse order
        for k = find(isnan(data(:,i)));  
            data(k,i) = data(k-1,i);
        end
    end
    data_filled = data;
endfunction
