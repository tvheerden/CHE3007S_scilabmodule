
function pairplot(varargin)
    // Function to plot pairwise relatioships within a dataset. A grid will be created with each variable plotted against the other. The diagonals will dispay the frequency distributions of the data, which can be plotted as a histogram or with kernel density estimation of the distribution
    //
    // Syntax
    // pairplot(header, data, column, png_name)
    // pairplot(header, data, column, png_name, sheader, sdata)
    // pairplot(header, data, column, png_name, sheader, sdata, hue)
    // pairplot(header, data, column, png_name, sheader, sdata, hue, hue_bin)
    // pairplot(header, data, column, png_name, sheader, sdata, hue, hue_bin, n_points)
    //
    // Parameters
    // header:  m x 1 vector of headers for numeric data
    // data:    n x m matrix of numeric data, with matrix of column vectors
    // column:  vector of columns indices or header labels which will be plotted
    // png_name: name for the png file to be exported
    // sheader: p x 1 matrix of corresponding headers for string/text data
    // sdata:   n x p matrix of string/text data with data as column vectors
    // hue:     label of field on which to split the data into different groups and colours for plotting
    // hue_bin: if hue column is corresponding to a numeric field, this is the the number of bins to split the data into linearly over range, the default for this is 5.
    // n_points: number of points for the kernel density estimation of the frequency distributions to be estimated over, more points result in a smoother curve. Default is 1000.
    
nin = size(varargin);
if nin<3 | nin>10
    error("Wrong number of input arguments provided. Expected between 3 and 9")
end

header = varargin(1);
num_data = varargin(2);
column = varargin(3);

if type(column)==10
    [match, match_ind, indices] = intersect(column, header);
    column = indices;
end

// Define defaults
n_points = 1000; // Default number of points for kde estimation
hue_bin = 5; // Number of bins for splitting data for grouping by hue paramter
hue = %f; // Default hue value, false means no hue calculation
leg = %f; // Default legend plotting is false
png_name = 'pairplot.png';

// Look through varargin to overwrite default
if size(num_data, 2) ~= size(header, '*')
    error("Dimensions of numeric data and header matrices must agree")
end

for i = 4:nin
    select i
    case 4
        if type(varargin(4))==10
            png_name = varargin(4);
        else
            png_name = %f;
        end
        
    case 5
        if nin < 6
            error("Headers for string data not provided, please provide corresponding headers");
        end
        
        sheader = varargin(5);
        sdata = varargin(6);
        
        if size(sdata, 2) ~= size(sheader, '*')
              error("Dimensions of string data and header matrices must agree");
        end
        
    case 7
        arg = varargin(7);
        if ~(or(arg == sheader) | or(arg == header))
            error("Hue not in header data, please provide a valid column name");
        elseif length(arg)==0
            hue = %f;
        else
            hue = arg;
        end
        
        // If hue based off a numeric column, then provide number of bins
        if or(hue == header)
            if nin<8
                hue_bin = hue_bin;
            elseif varargin(8)
                hue_bin = varargin(8);
            end
        end
        
    case 9
        if type(varargin(9)) ~= 1
            error("Integer type expected for number of points");
        end
        if varargin(9)
            n_points = varargin(9);
        end
    case 9
        if type(varargin(10))==4
            leg = varargin(10);
        else
            leg = %f;
        end
            
    end
end

// Define defaults
// Function starts here
n_p = n_points;
data = num_data(:, column);
labels = header(column);
n = size(data, 2);

fig = scf();
ax = gca();
fig.immediate_drawing = "off";
AX = [];
for i = 1:n
    for j = 1:n
        // First deal with the hues, if hue is provided as an 
        // input
        // -----------------------------------------------------
        if hue~=%f
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
                hue_data = num_data(:, hue==header);
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
            end
        else
            // No hues are defined then plot only on set of data
            hues = [];
            all_y = list(data(:, i));
            all_x = list(data(:, j));
        end
        
        // Plot the data in the subplot grid
        c = (i-1)*n + j; // Position of current plot
        
        subplot(n, n, c);
        ax = gca();
        AX(i,j) = ax; // Save axes for later changes
        
        // Loop through each hue split data and plot
        // -----------------------------------------------------
        for k = 1:size(all_y)
            y = all_y(k);
            x = all_x(k);
            
            // Decide how to plot based on the position in the grid
            if i == j;
                // If on the diagonal then plot the pdf curves
                
                // For the x values to estimate the kde over we
                // use a few more points before and after the 
                // end of the data range to get a smoother 
                // curve at the end points
                inter = (max(y)-min(y))/(n_p-1);
                xkde = linspace(min(y)-150*inter, max(y)+150*inter, n_p)';
                ykde = ksdensity(y, xkde);
                
                // Get data for plotting and dont exceed 
                // original axes bounds to prevent misalignment
                max_ys = max(data(:, j));
                min_ys = min(data(:, j));
                xplot = xkde(xkde>min_ys & xkde<max_ys);
                yplot = ykde(xkde>min_ys & xkde<max_ys);
                yplot = yplot/max(yplot)*max(data(:, j));
                
                // It seems that seaborn developers just cheated
                // here and scaled the first plot of the first
                // row to the max of the data so that they have 
                //the axes correct. I have replicated this 
                // behaviour
                if k == 1 & i == 1
                    plot(xplot, yplot);
                else
                    plot(xplot, ...
                        yplot/length(data(:,i))*length(y),...
                        'color', k+1);
                end
            else
                // If a normal plot then plot the data 
                // points as is
                plot(x, y, ...
                    'color', k+1, ...
                    'linestyle', 'none', ...
                    'marker', 'o');
            end
        end
        
        // Only label the first column and the last row
        if j == 1
            ylabel(labels(i))
        end
        
        if i == n
            xlabel(labels(j))
        end
    end
end


// Export data and display scaled version for screen
fig_size = [250*n 220*n];
fig.visible = 'off';
fig.immediate_drawing = "on";
fig.figure_size = fig_size;
old_size = fig.figure_size;
fig.position([3,4]) = fig_size;

// Look for smallest graph
y_margin = 0;
for i = 1:n
    margin = AX(i,1).margins(1);
    if margin > y_margin
        y_margin = margin;
    end
end

x_margin = 0;
for i = 1:n
    margin = AX(n, j).margins(4);
    if margin > x_margin
        x_margin = margin;
    end
end

// Loop through the axes after plotting and fix up the yticks, xticks and margins
for i = 1:length(AX(:, 1))
    // Set the margin of the first column to line up
    AX(i, 1).margins([1 2]) = [y_margin*0.9 0.06];
    for j = 1:n
        AX(n, j).margins([4]) = [x_margin];
        // Set the other columns margins larger
        if j > 1
//            AX(i, j).margins([1 2]) = [0.125, 0.1];
            
            // Update the yticks on the other columns
            yticks = AX(i, 1).y_ticks;
            yticks.labels = repmat("", length(yticks.locations), 1);
            AX(i, j).y_ticks = yticks;
            AX(i, j).sub_ticks(2) = AX(i, 1).sub_ticks(2);
        end
        
        // For all other rows not last
        if i < n
            // Update the xticks on the other rows
            xticks = AX(n, j).x_ticks;
            xticks.labels = repmat("", length(xticks.locations), 1);
            AX(i, j).x_ticks = xticks;
            AX(i, j).sub_ticks(1) = AX(n, j).sub_ticks(1);
        end
        
        // Delete ticks because I need to scale the kde curves accordingly and this is too much work
        if i == j & j > 1
            AX(i, j).y_ticks = tlist(...
                ["ticks"  "locations"  "labels"],...
                [],[]);
        end
        
    end
end

//xs2pdf(fig, 'pairplot.pdf');
//fig.visible = "on";
if leg & length(hues)>0
    leg_handle = legend(AX(int((n+1)/2),n), string(hues));
    //leg_handle.fill_mode = 'off';
    //leg_handle.line_mode = 'off'; 
end

if type(png_name)==10 then
    xs2png(fig, png_name);
    close(fig);
end


endfunction
