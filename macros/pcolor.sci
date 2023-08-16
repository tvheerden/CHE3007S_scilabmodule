function pcolor(data, varargin)
    // Function to generate a pseudocolor plot with a non-regular rectangular grid.
    //
    // Syntax
    // pcolor(data)
    // pcolor(data, labels)
    // pcolor(data, labels, direction)
    // pcolor(data, labels, direction, num_points)
    // pcolor(data, labels, direction, num_points, flip)
    //
    // Parameters
    // data:        Matrix of data to be plotted
    // labels:      Vector of strings to label data points
    // direction:   Direction to plot along x axis with 'r' or y axis with 'c'
    // num_points:  The number of points to include on colour map
    // flip:        Option to flip data on the x axis or not, %f or %t. Default value is %f
    
    // Define defaults
    labels = string([1:min(size(data))]);
    direction = 'r';
    num_points = 10000;
    flip = %f;
    
    // Overwrite defaults with varargin
    if argn(2)>0 
        for i = 1:length(varargin)
            
            select i
            case 1
                arg = varargin(1);
                if length(arg)>0
                    labels = arg;
                end
            case 2
                arg = varargin(2);
                if length(arg)==0
                    direction = direction;
                elseif arg~='r' | arg~='d'
                    error('Direction must either be r or c')
                else
                    direction = varargin(2);
                end
            case 3
                arg = varargin(3);
                if length(arg)>0
                    num_points = arg;
                end
            case 4
                arg = varargin(4);
                if length(arg)>0
                    flip = arg;
                end
            end
            
        end
    end
    
    n_cols = max(size(labels));
    if n_cols ~= min(size(data)) then
        error("Input data should have same dimensions as labels");
    end
    // Do argument handling still
    
    // Transpose the data to have the rows of the columns going across the xax
    // and flip the data going left to right to match python pcolo
    if size(data, 2)==n_cols
        data = data(:, $:-1:1)';
    else
        data = data($:-1:1, :);
    end
    
    // Flip the data if required
    if flip==%f
        [m, i] = max(size(data));
        if i==2
            data = data(:, $:-1:1)
        elseif i==1
            data = data($:-1:1, :);
        end
    end
    
    if direction == 'c'
        data = data';
    end
    
    // Data to matplot needs to provided as integers, we need to scale the data
    // based on a number of points we would like on our colour bar
    n = max(data) - min(data);
    scale_factor = num_points/n;
    if scale_factor > 1
        scaled_data = int(((data - min(data)))*scale_factor);
    else
        scaled_data = int(data - min(data));
    end
    
    // Plot data with colormap
    f = gcf();
    ax = gca();
    f.color_map = jetcolormap(max(scaled_data)+1);
    Matplot(scaled_data+1)
    tick_loc = 1:max(size(labels));
    ticks = tlist(["ticks"  "locations"  "labels"], tick_loc, labels);
    
    if direction == 'r' then
        ax.y_ticks = ticks;
    else
        ax.x_ticks = ticks;
    end
    
    
    // Colorbar with label minima and maxima 
    colorbar(min(data), max(data))
endfunction
