
function dfhead(header, data, varargin)
    // Function to return the first 10 rows of a data matrix
    //
    // Syntax
    //   dfhead(header, data)
    //   dfhead(header, data, n_rows)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // nrows:   integer, number of rows to return

    // Description
    // function prints top 10 rows of data matrix to console, neatly formatted and with headers

    nrows = 10;
    [lhs, rhs] = argn();
    
    if size(varargin) > 0 then
        nrows = varargin(1)
        if isempty(nrows) then     // check that value is an integer
            nrows = 10
        elseif ~(modulo(nrows,1) == 0) then
            nrows = 10
        end
    end
    
    if size(varargin) == 2 | size(varargin) > 3 then
        disp('incorrect number of input arguments. 2, 3, or 5 expected')
        abort
    end
    
    if size(varargin) == 1 then
        sdata = []
        sheader = []
    end

    // check header is a row
    if size(header)(1) > size(header)(2) then
        disp('warning: header is in shape of a column');
        header = header';
    end
    
                // check sheader is a row
    if size(sheader)(1) > size(sheader)(2) then
        disp('warning: sheader is in shape of a column');
        sheader = sheader';
    end
    
    if sheader == [] then
        m = nrows*ones(header);
        print_string_1 = '%s '+ strcat('%'+string(max([length(header); m], 'r'))+'s   ');
        // Print the header formatted
        mprintf('\n\n');
        mprintf(print_string_1, '     ', header);
        mprintf('\n');
        
        print_string_2 = '%4i '+ strcat('%'+string(max([length(header); m], 'r'))+'.6g   ')+'\n';
        mprintf(print_string_2, [1:nrows]', data(1:nrows, :));
        mprintf('. . . . . . .\n');
    else
        m = 10*ones(header);
        n = 10*ones(sheader);
        n(1) = 20;
        
        print_string_1 = '%s '+ strcat('%'+string(max([length(sheader); n], 'r'))+'s   ')+ strcat('%'+string(max([length(header); m], 'r'))+'s   ');
        // Print the header formatted
        mprintf('\n\n');
        mprintf(print_string_1, '     ', [sheader, header]);
        mprintf('\n');
        
        print_string_2 = '%4i '+ strcat('%'+string(max([length(sheader); n], 'r'))+'s   ')..
                               + strcat('%'+string(max([length(header); m], 'r'))+'.6g   ')+'\n';
        mprintf(print_string_2, [1:nrows]', sdata(1:nrows,:), data(1:nrows, :));
        mprintf('. . . . . . .\n');
    end
    
endfunction
