function [dsdata, ds_datetime, ds_datetime_serial] = downsample(data, datetime, separators, frequency, method)
    // Short description on the first line following the function header.
    //
    // Syntax
    //   [dsdata, ds_datetime, ds_datetime_serial] = downsample_v2(data, datetime, separators, frequency, method)
    //
    // Parameters
    // dsdata: n x m matrix of values, downsampled data
    // ds_datetime: n x 6 matrix of values, downsampled datetime. columns are arranged as [year, month, day, hour, minute, second] 
    // ds_datetime_serial: n x 1 column vector of values, downsampled datetime in serial datetime format. 
    //
    // data: N x m matrix of values, data to be downsamples
    // datetime: N x 1 vector of strings, date and time data
    // separators: row vector of strings, all separators required for splitting datetime
    // frequency: string value, downsampling frequency. Options are minutely, hourly, daily, monthly, annually. OR supply frequency as a vector of values in the format [Years Months Days Hours Minutes Seconds].
    // method: string variable, mean, median or stdev
    
    
    // Functions structure
    functions = struct();
    functions("mean") = nanmean;
    functions("median") = median;
    functions("stdev") = nanstdev;
    fun = functions(method);
    
    if frequency == 'minutely' | frequency == [0 0 0 0 0 60] then
        frequency = [0 0 0 0 1 0];
    elseif frequency == 'hourly' | frequency == [0 0 0 0 60 0] then 
        frequency = [0 0 0 1 0 0];
    elseif frequency == 'daily' | frequency == [0 0 0 24 0 0] then
        frequency = [0 0 1 0 0 0];
    elseif frequency == 'monthly' then
        frequency = [0 1 0 0 0 0];
    elseif frequency == 'annualy' then
        frequency = [1 0 0 0 0 0]; 
    end
    
    k = find(frequency ~= 0);
    if k == 6 then
        disp('\n\n!!! function not built to downsample per second!!!\n\n')
        abort
    end

    frequency_serial = datenum(frequency+[2 2 2 2 0 0]) - datenum([2 2 2 2 0 0])

    for i = 1:size(datetime, '*')
       YMDHms(:,i) = strtod(tokens(datetime(i), separators));
    end
    YMDHms = YMDHms';
    datetime_serial = datenum(YMDHms);
    
    ds_date_i = datetime_serial(1);
    ds_date_n = datetime_serial($);
    ds_datetime_serial = ds_date_i:frequency_serial:ds_date_n;

    ds_datetime = datevec(ds_datetime_serial);
    ds_datetime_serial = ds_datetime_serial'; 

    bin = ones(data(:,1));
    for i = 1:length(ds_datetime_serial)
        j = find(datetime_serial >= ds_datetime_serial(i),1)
        bin(j:$) = i
    end
    
    bins = 1:max(bin)
    for i = 1:length(bins)
        condition = bin == bins(i);
        if ~isempty(data(condition, :)) then
            grp(string(bins(i))) = fun(data(condition), 'r');
            dsdata(i, :)=fun(data(condition, :),'r');
        else
            dsdata(i, :) = %nan
    end
    
    end
endfunction
