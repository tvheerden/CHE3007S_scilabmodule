
function smooth_data = rolling_average(data, win_size)
    // Determine rolling averages to smooth out noisy data
    //
    // Syntax
    //   smooth_data = rolling_average(data, win_size)
    //
    // Parameters
    // smooth_data: matrix of values containing smoothed out data
    // data: matrix of values, original noisy data 
    // win_size: value describing nr of data points to be included in the window
    
    smooth_data = zeros(data)
    w = win_size;
    for i = 1:length(data)
        if i <= ceil(win_size/2)
            smooth_data(i) = mean(data(1:i+floor(w/2)));
        elseif i <= length(data)-floor(w/2);
            smooth_data(i) = mean(data(i-ceil(w/2):i+floor(w/2)));
        else
            smooth_data(i) = mean(data(floor(w/2):$));
        end
    end
endfunction
