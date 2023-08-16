
function [data_filled]=backfill(data);
    // Function to backfill %nan values in data matrix
    //
    // Syntax
    //   [data_filled]=backfill(data);
    //
    // Parameters
    // data_filled:  n x m matrix of numeric data, with matrix of column vectors, where %nan values of input matrix have been backfilled
    // data:    n x m matrix of numeric data, with matrix of column vectors

    // Description
    // Function to backfill %nan values in numeric data marix. For special case where final value is %nan, we use forward filling for this and then backfill for rest
    
    [nr, nc] = size(data);
    for i = 1:nc;
        if isnan(data($,i)) then
            data($,i) = data(~isnan(data(:,i)),i)($); // replace with the last non-nan nr
        end
        
        // for all nan entries in reverse order
        for k = flipdim(find(isnan(data(:,i))),2);  
            data(k,i) = data(k+1,i);
        end
    end
    data_filled = data;
endfunction
