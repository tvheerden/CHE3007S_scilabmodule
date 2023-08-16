
function ranks = rank_data(data)
    // A function to assign a rank to the data
    //
    // Syntax
    // ranks = rank_data(data)
    //
    // Parameters
    // data: a vector of data to be ranked
    // ranks: a vector containing the rank scores
    [sx, rowidx] = mtlb_sort(data(:));
    n = length(sx);
    
    ranks = [1:n]';
    tieadj = 0;
    ties = (sx(1:n-1) == sx(2:n));
    tieloc = [find(ties)'; n+2];
    maxTies = length(tieloc);
    
    tiecount = 1;
    while (tiecount < maxTies)
        tiestart = tieloc(tiecount);
        ntied = 2;
        while(tieloc(tiecount+1) == tieloc(tiecount)+1)
            tiecount = tiecount+1;
            ntied = ntied+1;
        end
        tieadj = tieadj + ntied*(ntied-1)*(ntied+1)/2; 
        ranks(tiestart:tiestart+ntied-1) =  sum(ranks(tiestart:tiestart+ntied-1)) / ntied;
        tiecount = tiecount + 1;
    end
    
    // Unsort the data back into original order
    unsorted = 1:length(data);
    unsort_ind(rowidx) = unsorted;
    ranks = ranks(unsort_ind);
endfunction

