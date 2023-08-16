function [header, data, sheader, sdata] = ingestCSV(file_name, header_rows, varargin)
    // Utility function for ingesting and splitting csv data.
    //
    // Syntax
    //   [header, data, sheader, sdata] = ingestCSV(file_name, header_rows)
    //   [header, data, sheader, sdata] = ingestCSV(file_name, header_rows, datetime_col)
    //   [header, data, sheader, sdata] = ingestCSV(file_name, header_rows, datetime_col, datetime_separators)
    //   [header, data, sheader, sdata] = ingestCSV(file_name, header_rows, datetime_col, datetime_separators, separator)
    //   [header, data, sheader, sdata] = ingestCSV(file_name, header_rows, datetime_col, datetime_separators, separator, decimal)
    //
    // Parameters
    // header: 1 x m vector of strings, header of each column of data in the data matrix
    // data: n x m matrix of values, each column corresponds to a header
    // sheader: 1 x k vector of strings, header of each column of data in the string data matrix
    // data: n x k matrix of string formatted data/labels/tags, each column corresponds to a header in the sheader vector
    // file_name: a string variable pointing to the location of the csv to be ingested
    // header_rows: an integer, number of rows at beginning of csv that contain header data
    // datetime_col: an integer, points to the column number that contains datetime data in the csv
    // datetime_separators: a vector of strings, the separators to be used for splitting the datetime data into year, month, day, etc
    // separator: a string variable, the separator used in the csv (default [] is ',')
    // decimal: a string variable, the symbol representing the decimal in the csv data (default [] is '.')
    //
    
    n = header_rows;
    header = [];
    data = [];
    sheader = [];
    sdata = [];
    
    separator = [];
    decimal = []; 
    datetime_col = [];
    datetime_separators =[' ', '/', ':'];
    
    [lhs, rhs] = argn();
    
    if rhs > 2 then
        if length(varargin)>0 then
            datetime_col = varargin(1);
        end
        if length(varargin)>1 then
            datetime_separators = varargin(2);
        end
        if length(varargin)>2 then
            separator = varargin(3);
        end
        if length(varargin)>3 then
            decimal = varargin(4);
        end
        if length(varargin)>4 then
            disp('too many input arguments supplied')
        end
    end
    
    if n > 0 then
        header = csvRead(file_name, separator, decimal, 'string', [], [], [1 1 n 2e9]);
        data = csvRead(file_name, separator, decimal, [], [], [], [], n);
    else
        data = csvRead(file_name, separator, decimal, [], [], [], []);
    end
    
    str_cols = find(and(isnan(data), 'r'));     // check if any string columns
    num_cols = find(~and(isnan(data), 'r'));
    if ~isempty(str_cols) then
        if n > 0 then
            sdata = csvRead(file_name, separator, decimal, 'string', [], [], [], n);
            sheader = header(:, str_cols);
        else
            sdata = csvRead(file_name, separator, decimal, 'string', [], [], []);
        end
        num_cols = [datetime_col, num_cols];
        sdata = sdata(:, str_cols);
    end
    
    if ~isempty(datetime_col) then
            datetime = csvRead(file_name, separator, decimal, 'string', [], [], [1 datetime_col 2e9 datetime_col], n);
            for i = 1:size(datetime, '*')
                YMDHms(:,i) = strtod(tokens(datetime(i), datetime_separators));
            end
            YMDHms = YMDHms';
            datetime_serial = datenum(YMDHms);
            data(:, datetime_col) = datetime_serial;
            data = data(:, num_cols);
            header = header(:, num_cols);
    end
endfunction
