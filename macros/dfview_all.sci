function dfview_all(header, data, varargin)
    // Function to return a full data matrix, formatted neatly with headers
    //
    // Syntax
    //   dfview_all(header, data)
    //   dfview_all(header, data, sheader, sdata)
    
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // sheader: k x 1 vector of headers for string data matrix
    // sdata: n x k matrix of string data, matrix of column vectors

    // Description
    // function prints contents of data matrix to console, neatly formatted and with headers
    


    [lhs, rhs] = argn();
    
    if rhs == 2 then
        sdata = []
        sheader = []
    elseif rhs > 4
        disp('too many input arguments, 2 or 4 expected')
        abort
    elseif rhs == 3
        disp('incorrect nr of input arguments (3), 2 or 4 expected')
        abort
    else
        sheader = varargin(1)
        sdata = varargin(2)
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
    
    [nr nc] = size(data);
    
    if sheader == [] then
        m = 10*ones([header]);
        print_string_1 = '%s '+ strcat('%'+string(max([length(header); m], 'r'))+'s   ');
        // Print the header formatted
        mprintf('\n\n');
        mprintf(print_string_1, '     ', header);
        mprintf('\n');
        
        print_string_2 = '%4i ' + strcat('%'+string(max([length(header); m], 'r'))+'.6g   ')+'\n';
        mprintf(print_string_2, [1:nr]', data);
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
        mprintf(print_string_2, [1:nr]', sdata, data);
        mprintf('. . . . . . .\n');
    end
//    
//    
//    
//    
//        // check header is a row
//    if size(header)(1) > size(header)(2) then
//        disp('warning: header is in shape of a column');
//        header = header';
//    end
//    [nr nc] = size(data);
//    
//    m = nr*ones(header);
//    print_string_1 = '%s '+ strcat('%'+string(max([length(header); m], 'r'))+'s   ');
//    // Print the header formatted
//    mprintf('\n\n');
//    mprintf(print_string_1, '     ', header);
//    mprintf('\n');
//    
//    print_string_2 = '%4i '+ strcat('%'+string(max([length(header); m], 'r'))+'.6g   ')+'\n';
//    mprintf(print_string_2, [1:nr]', data);
endfunction
