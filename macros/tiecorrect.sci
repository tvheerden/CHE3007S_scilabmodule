
function tie = tiecorrect(ranks)
    // A function to calculate the tie correction factor for H tests
    //
    // Syntax
    // tie = tiecorrect(ranks)
    // 
    // Parameters
    // ranks: A vector of the computed rank values
    // tie: The tie correction for the H test
    
    n = length(ranks)
    ranks = gsort(ranks, 'g', 'i');;
    idx = find([%t; ranks(2:$) ~= ranks(1:$-1); %t]);
    cnt = diff(idx);
    
    if n < 2 
        tie = 1.0 ;
    else 
        tie = 1.0 - sum(cnt^3-cnt) / (n^3 - n);
    end
endfunction
