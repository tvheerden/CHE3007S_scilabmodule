function [p, h] = kruskal(varargin)
    // Returns the p, h-test value for the kruskal-wallis test. Provide input as a matrix, list of matrices or multiple matrices
    
    // Syntax
    // [p, h] = kruskal(samples)
    // [p, h] = kruskal(sample1, sample2...)
    
    // Parameters
    // p: The p-value assuming that the H statistic has a chi scquare distributions.
    // h: The tie corrected Kruskal-Wallis H statistic
    // samples:
    
    // Get lengths of each array for indexing in stacked matrix
    n = [];
    for i = 1:length(varargin)
        n(i) = length(varargin(i));
    end
    
    // Rank all data and calculate ties
    alldata = list2vec(varargin);
    ranked = rank_data(alldata);
    ties = tiecorrect(ranked);
    
    // Calculate H
    num_groups = length(varargin); // Number of sample vectors
    j = [0; cumsum(n)]; // Indices of each matrix start
    sumterm = 0; // Initialise sum term
    for i = 1:num_groups
        sumterm = sumterm + (sum(ranked(j(i)+1:(j(i+1))))^2) / n(i)
    end
    totaln = sum(n);
    h = 12.0 / (totaln * (totaln + 1)) * sumterm - 3 * (totaln + 1);
    df = num_groups - 1;
    h = h/ties;
    [P, p] = cdfchi("PQ", h, df)
endfunction


