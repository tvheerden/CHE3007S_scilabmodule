function [datascaled] = zscore(data)
    // Function to perform zscore scaling on data
    //
    // Syntax
    //   [datascaled] = zscore(data)
    //
    // Parameters
    // datascaled: matrix of values, each column scaled using zscore
    // data: matrix of values, data supplied which is to be scaled 
        
        datascaled = zeros(data);
        m = nanmean(data,'r');
        s = nanstdev(data,'r');
        [nr, nc] = size(data);
        for i = 1:nc
            datascaled(:,i) = (data(:,i)-m(i))/s(i)
        end
endfunction
