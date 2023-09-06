function heatmap(data, varargin)
    // Function to plot a colour encoded matrix as a heatmap
    //
    // Syntax
    // heatmap(data)
    // heatmap(data, num_points)
    // heatmap(data, num_points, colormap)
    // heatmap(data, num_points, colormap, [c_min c_max])
    // heatmap(data, num_points, colormap, [c_min c_max], annot)
    // heatmap(data, num_points, colormap, [c_min c_max], annot, mask)
    //
    // Parameters
    // num_points:  Number of points for the colormap/colorbar
    // colormap:    Provide a colormap function to use to generate a colormap
    // c_min:       Minimum value for colormap
    // c_max:       Maximum value for colormap
    // annot:       Annotation of values on graph, %t or %f
    // mask:        A mask matrix of ones and zeros to apply to the data, where 1 indicates data to be plotted, and 0 indicates data to be ignored
    
    // Define defaults
    labels = string([1:min(size(data))]);
    n_cols = max(size(labels));
    
    // Define default values
    num_points = 10000;
    colormap = jetcolormap;
    annot = %f;
    cmin = min(data)
    cmax = max(data)
    mask = ones(n_cols, n_cols);
    
    // Optional arguments
    nin = length(varargin)
    for c = 1:nin
        arg = varargin(c);
        select c
        case 1
            if length(arg)>0
                num_points = arg;
            end
        case 2
            if type(arg)==13
                colormap = arg;
            else
                error('Wrong type for input argument colormap, a function was expected')
            end
        case 3
            if length(arg)==2
                c_min = arg(1);
                c_max = arg(2);
            else
                error('Wrong sized matrix received for [c_min c+_max]. 2x1 matrix expected')
            end
        case 4
            if ~isempty(arg)
                annot = arg;
            end
        case 5
            if ~isempty(arg)
                mask = arg;
            end
        end
    end
    

    if n_cols ~= min(size(data)) then
        error("Input data should have same dimensions as labels");
    end
    
    // Data to matplot needs to provided as integers, we need to scale the data
    // based on a number of points we would like on our colour bar
    
    if length(c_min)==1
        x = data-c_min;
        
        n = c_max-c_min;
        scale_factor = num_points/n;
        scaled_data = x*scale_factor;
    end
    
    // Plot data with colormap
    f = gcf();
    ax = gca();
//    f.color_map = colormap(max(scaled_data)+1);
    f.color_map = colormap(int((c_max-c_min)*scale_factor)+1);
    Matplot(scaled_data+1);
    
    // Adjust ticks
    tick_loc = 1:max(size(labels));
    ticks = tlist(["ticks"  "locations"  "labels"], tick_loc, labels);
    ax.x_ticks = ticks;
    ax.y_ticks = ticks;
    
    // Colorbar with label minima and maxima
    if length(c_min)==0
        c_min = min(data);
        c_max = max(data);
    end
    
    colorbar(c_min, c_max);
    
    // Annotate
    if annot
        for i = 1:n_cols
            for j = 1:n_cols
                if mask(n_cols-i+1, n_cols-j+1)==1
                    str = sprintf('%0.2f',data(j,i));
                    rect = stringbox(str, i, n_cols-j+1);
                    xh = rect(1,3)-rect(1,1);
                    xv = rect(2,1)-rect(2,2);
                    xstring(i-xh/2, n_cols-j+1+xv/2, str);
                end
            end
        end
    end
    
    if ~isempty(mask)
        // Adjust colormap to have white as the final color to clear empty areas of plot
        f.color_map = [f.color_map; [1 1 1]];
        dat = f.children(2).children($).data;
        
        dat(mask~=1) = length(f.color_map);
        f.children(2).children($).data = dat;
    end
endfunction

