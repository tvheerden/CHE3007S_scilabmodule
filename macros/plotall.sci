function plotall(header, data, varargin)
    // Function to plot time series data for many variables. Automatically opens appropriate nr of figure windows.
    //
    // Syntax
    //   plotall(header, data)
    //   plotall(header, data, datetime)
    //   plotall(header, data, datetime, export)
    //
    // Parameters
    // header: vector of strings, labels for each column of data in data
    // data: matrix of values to plot. column 1 is x axis data every other column is plotted against. 
    // datetime: vector of strings to be used as x-axis labels, corresponding to data(:,1)
    // export: boolean variable allowing for image export to png, default is %f
    
    export = %f
    
    [lhs,rhs]=argn(0);      // check nr of inputs / outputs
    if rhs > 2 then         // optional argument supplied
        datetime = varargin(1);
        n = 4                       // nr of x data labels
        loc = [linspace(data(1,1), data($,1), n)]';     // location of x ticks
        label = datetime(round(linspace(1,size(datetime,'*'),n)));        // label of x ticks
        [nr, nc] = size(label); 
        blank_label = repmat(' ', nr, nc);      // blank labels of same size as label
        if rhs > 3 then
            export = varargin(2)
        end
    end
    
  m = size(data, 'c');        // nr of columns to plot
   
  if m-1 <= 5 | export then
    row = m-1;     // number of subplot rows
       figs = 1;     // number of figure windows
   else
       figs = ceil((m-1)/5);        // nr of figure windows
       row = m - 1 - 5*(figs-1);    // nr of subplot rows in FINAL figure window
   end
   
   k = 2;                   // column tracker
   style = 1;               // style tracker
   
   for j = 1:figs;          // for each figure window
       if export then
           fig = scf();
           ax = gca();
           fig.immediate_drawing = "off";
           AX = [];
       else
           scf(), clf();        // initialize figure window
       end
       
       if j == figs;
           for i = 1:row;       // for every row (final figure window)
               subplot(row,1,i);
               ax = gca()
               AX(i,j) = ax; // Save axes for later changes
               if style == 8;       // style = 8 is white line, skip
                   style = 9;
               end
 
               plot2d(data(:,1), data(:,k),style);  // plot
               legend(header(k),-5);             // label
               k = k+1;                         // update column tracker
               style = style + 1;
               g = gca();                       // get current axes
               l = g.children(1);               // get current legend
               l.fill_mode = 'off';             // unfill legend box
               if i == row & rhs > 2 then                     // select either label (if bottom row) or blank label
                   g.x_ticks = tlist(["ticks", "locations", "labels"], loc, label);
               elseif rhs >2 then
                   g.x_ticks = tlist(["ticks", "locations", "labels"], loc, blank_label);
               end
           end
           
       else
           for i = 1:5;
               subplot(5,1,i);
               if style == 8;
                   style = 9;
               end
               plot2d(data(:,1), data(:,k),style);
               legend(header(k),-5);
               k = k+1;
               style = style + 1;
               g = gca();
               l = g.children(1);
               l.fill_mode = 'off';
               if i == 5 & rhs>2;
                   g.x_ticks = tlist(["ticks", "locations", "labels"], loc, label);
               elseif rhs >2
                   g.x_ticks = tlist(["ticks", "locations", "labels"], loc, blank_label);
               end
           end
       end
   end
   
   if export  then
        fig_size = [1000*n 220*n];
        fig.visible = 'off';
        fig.immediate_drawing = "on";
        fig.figure_size = fig_size;
        old_size = fig.figure_size;
        fig.position([3,4]) = fig_size;
        xs2png(fig, 'plotall');
        close(fig);
    else
        fig.immediate_drawing = "on";
   end

endfunction
