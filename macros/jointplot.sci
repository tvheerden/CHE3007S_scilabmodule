
function jointplot(header, data, x, y, varargin)
    // Function to plot a colour encoded matrix as a heatmap
    //
    // Syntax
    // jointplot(header, data, x, y)
    // jointplot(header, data, x, y, sheader, sdata, hue)
    // jointplot(header, data, x, y, sheader, sdata, hue, hue_bin)
    // jointplot(header, data, x, y, sheader, sdata, hue, hue_bin, n_points)
    // jointplot(header, data, x, y, sheader, sdata, hue, hue_bin, n_points, dist_type)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // x:       column number or column name to be plotted on x axis
    // y:       column number or column name to be plotted pn y axis
    // sheader: p x 1 matrix of corresponding headers for string/text data
    // sdata:   n x p matrix of string/text data with data as column vectors
    // hue:     label of field on which to split the data into different groups and colours for plotting
    // hue_bin: if hue column is corresponding to a numeric field, this is the the number of bins to split the data into linearly over range, the default for this is 5.
    // n_points:    number of point for colormap/colorbar, default is 10000
    // dist_type:   distribution type for the plot, 'kde' or 'hist'. The default value is 'hist', for a histogram plot
    if type(x)==10 then
        j = find(header == x);
        if length(j)==0
            error('x Column not found in header data')
        end
    else
        j = x
    end
    
    if type(y)==10 then
        i = find(header == y);
        if length(i)==0
            error('x Column not found in header data')
        end
    else
        i = y
    end
    // Set default values for optional arguments
    n_p = 1000;
    dist_type = 'hist';
    nin = length(varargin);
    hue = %f;
    
    for cases = 1:nin
        select cases
        case 1
            if nin < 2
                error("Headers for string data not provided, please provide corresponding headers");
            end
            
            sheader = varargin(1);
            sdata = varargin(2);
            
            if size(sdata, 2) ~= size(sheader, '*')
                error("Dimensions of string data and header matrices must agree");
            end

        case 3
            arg = varargin(3);
            if ~(or(arg == sheader) | or(arg == header))
                error("Hue not in header data, please provide a valid column name");
            elseif length(arg)==0
                hue = %f;
            else
                hue = arg;
            end

            // If hue based off a numeric column, then provide number of bins
            if or(hue == header)
                if nin<4
                    hue_bin = hue_bin;
                elseif varargin(4)
                    hue_bin = varargin(4);
                end
            end

        case 5
            if type(varargin(5)) ~= 1
                error("Integer type expected for number of points");
            end
            if varargin(5)
                n_p = varargin(5);
            end
            
        case 6
            if or(varargin(6)==['kde' 'hist'])
                dist_type = varargin(6)
            else
                error('Wrong value encountered for distribution type. Values must be either kde or hist')
            end
            
        end
    end
    
    if or(hue == sheader) then
        // If the hue is one of the string values then split
        // the data on the hue
        // Initialize the lists
        all_y = list();
        all_x = list();

        // Find the unique hue values for splitting the data
        hue_data = sdata(:, hue==sheader);
        hues = unique(hue_data);
        hues(hues=="") = []; // Ignore empty values

        // Split the data on the hues
        for k = 1:size(hues, '*');
            all_y(k) = data(hue_data==hues(k), i);
            all_x(k) = data(hue_data==hues(k), j);
        end
    elseif or(hue == header)
        // Initialize the lists
        all_y = list();
        all_x = list();

        // If the hue is in the numeric data, split the data into bins
        hue_data = data(:, hue==header);
        hues = linspace(min(hue_data), max(hue_data), hue_bin);
        for k = 1:hue_bin;
            if k < hue_bin
                con = hue_data>hues(k)&hue_data<hues(k+1);
                all_y(k) = data(con, i);
                all_x(k) = data(con, j);
            else
                con = hue_data<hues(k)&hue_data>hues(k-1);
                all_y(k) = data(con, i);
                all_x(k) = data(con, j);
            end
        end
        hues = string(hues(1:$-1));
    elseif hue==%f
        all_y = list(data(:,i));
        all_x = list(data(:,j));
    end
    
    function [yplot, xplot] = kde(y, data, i, n_p)
        // Utility function to split data and perform kde calculations
        //-150 and +150 points on either side to smooth the distributions on the edges and not just cut off at last data point. Increasing the magnitude of this value will always make the curves better at egdes, but will mess with x-axis
        inter = (max(y)-min(y))/(n_p-1);
        xkde = linspace(min(y)-150*inter, max(y)+150*inter, n_p)';
        ykde = ksdensity(y, xkde);

        // Get data for plotting and dont exceed 
        // original axes bounds to prevent misalignment
        max_ys = max(data(:, i));
        min_ys = min(data(:, i));
        xplot = xkde(xkde>min_ys & xkde<max_ys);
        yplot = ykde(xkde>min_ys & xkde<max_ys);
        yplot = yplot/max(yplot)*sum(yplot)/sum(data(:, i))*sum(y);
    endfunction

    for k = 1:length(all_y)
        xsetech([0,0.1,0.9,0.9]);
        scatter(all_x(k), all_y(k),'markerFaceColor', k+1, 'markerEdgeColor', 'w')
        ax1 = gca();

        // Plot ys
        xsetech([0.8,0.1,0.2,0.9]);
        y = all_y(k);
        // Plot data depending on chosen input
        if dist_type=='kde'
            [yplot, xplot] = kde(y, data, i, n_p);
            plot(xplot, yplot, 'color', k+1);
        else
            n_bins = calculate_bins(data(:, i), y);
            colour = gcf().color_map(k+1,:)*255;
            histo(y, n_bins, "FaceColor", colour);
        end
        
        ax2 = gca();
        ax2 = gca();
        ax2.view = "3d";
        ax2.rotation_angles = [180,360];
        ax2.axes_visible = ["off","off","off"];

        // Plot xs
        xsetech([0,0,0.9,0.2]);
        x = all_x(k);
        // Plot data depending on chosen input
        if dist_type=='kde'
            [yplot, xplot] = kde(x, data, j, n_p);
            plot(xplot, yplot, 'color', k+1);
        else
            n_bins = calculate_bins(data(:, j), x);
            colour = gcf().color_map(k+1,:)*255;
            histo(x, n_bins+1, "FaceColor", colour);
        end
        
        ax3 = gca();
        ax3.axes_visible = ["off","off","off"];
    end
    
    sca(ax1);
    legend(ax1, hues);
endfunction
