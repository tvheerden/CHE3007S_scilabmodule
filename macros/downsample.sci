function [dsdata, dsdatetime] = downsample(data, datetime, separators, frequency, method)
    // Short description on the first line following the function header.
    //
    // Syntax
    //   [dsdata, dsdates] = downsample(data,YMDHms, frequency, method)
    //
    // Parameters
    // dsdata: n x m matrix of values, downsampled data
    // dsdatetime: n x 1 vector of values, downsampled  
    // data: the z parameter   // separated by ":".
    // datetime: N x 1 vector of strings, date and time data
    // separators: row vector of strings, separators required for splitting datetime
    // frequency: string value, downsampling frequency. Options are minutely, hourly, daily, monthly, annually. Or supply frequency as a vector of values in the format [Years Months Days Hours Minutes Seconds].
    // method: string variable, mean or median


    if frequency == 'minutely' then
        frequency = [0 0 0 0 1 0];
    elseif frequency == 'hourly' then 
        frequency = [0 0 0 1 0 0];
    elseif frequency == 'daily' then
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
    
    for i = 1:size(datetime, '*')
       YMDHms(:,i) = strtod(tokens(datetime(i), separators));
    end

    w = find(and([YMDHms(k+1:$,:) == 0; modulo(YMDHms(k,:),frequency(k))==0],'r'));

    dsdatetime = datetime(w)
        if method == 'median' then
            for i = 1:length(w)-1;
                dsdata(i,:) = nanmedian(data(w(i):w(i+1),:),'r');
            end
        elseif method == 'mean' then
            for i = 1:length(w)-1; 
                dsdata(i,:) = nanmean(data(w(i):w(i+1),:),'r');
            end
        else
            print('\n\n!!!invalid method selected. method == median or mean!!!\n\n')
            abort
        end

endfunction
