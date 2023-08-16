function che_boxplot(varargin)
    // Draw a box-and-whiskers plot for data provided as column vectors.
    //
    // Syntax
    //  che_boxplot(y1[,y2,...])
    //  che_boxplot(y1[,y2,...], G)
    //  che_boxplot(Y_list)
    //  che_boxplot(y1[,y2,...], G, orientation)
    //
    // Parameters
    //  y1,y2,... : vectors and/or matrixes with data as column vectors (of varying length)
    //  G: string vector defines the column by strings
    //  Y_list : list of vectors and/or matrixes with data as column vectors (of varying length)
    // orientation: Orientation to plot the diagrams, forizontal or vertical, 'h' or 'v' 
    //
    // Description
    //  A boxplot (also known as a box-and-whisker plot is a way of
    //  graphically depicting groups of numerical data through their five-number summaries
    //  (the smallest observation, lower quartile (Q1), median, upper quartile (Q3), and
    //  largest observation). A boxplot may also indicate which observations, if any,
    //  might be considered outliers. The boxplot was invented in 1977 by the
    //  American statistician John Tukey.
    //
    //  For each data series a box is drawn to indicate the position of the lower and upper
    //  quartile of the data. The box has a centre line indicating the median of the data.
    //  Straigh center lines (the whiskers) above and below the box indicates the
    //  maximum and minimum values in the data set (except for outliers).
    //  Outliers are defined as any points larger than Q3 + 1.5*IQR or lower then
    //  Q1 - 1.5*IQR, where IQR is the inter quartile range defined as IQR=Q3-Q1.
    //  Outliers are plotted as individual '*'.
    //
    //  Boxplots can be useful to display differences between populations without making
    //  any assumptions of the underlying statistical distribution. The spacings between
    //  the different parts of the box help indicate the degree of dispersion (spread) and
    //  skewness in the data, and identify outliers.
    //
    // Examples
    //  nan_boxplot([rand(10,5);5*rand(5,5)-2.5])
    //  nan_boxplot() // demo and help
    //
    // Bibliography
    //  http://en.wikipedia.org/wiki/Box_plot
    //
    // Authors
    //  T. Pettersen (2008)
    // Adapted by
    //  Dominic de Oliveira (2023)
    //  Tracey van Heerden (2023)

    // This program is distributed in the hope that it will be useful,
    // but WITHOUT ANY WARRANTY; without even the implied warranty of
    // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    // GNU General Public License for more details.
    colors = [0 0 1;
            0 0.5 0;
            1 0 0 ;
            0 0.75 0.75;
            0.75 0 0.75;
            0.75 0.75 0;
            0.25 0.25 0.25;]
            
    if argn(2)==0 then
        boxplot([rand(10,5);5*rand(5,5)-2.5]);
        xtitle("boxplot() draws a Box and Whiskers plot","Data series no.","Data range");
        help boxplot
        return;
    end
    
    orientation = 'v';
    
    X=0; wd=1/4; style="k-"; change_column_names=%f;
    line_width = 2;
    set(gcf(),"immediate_drawing","off");
    set(gcf(),"color_map",colors);
    
    if type(varargin(1))==15 then
        N=length(varargin(1));
        for i = 2:length(varargin)
            arg = varargin(i);
            if arg == 'h' | arg=='v'
                orientation = arg;
            elseif type(arg)==10
                change_column_names=%t;
                column_names=arg;
            end
        end
    else 
        N=argn(2);
    end;


    for i=1:N,
        if type(varargin(1))==15 then
            Y=varargin(1)(i);
        else
            Y=varargin(i);
        end;
        if type(Y)==10 & (Y=='h' | Y=='v')
            orientation = Y;
        elseif type(Y) == 10
            change_column_names=%t;
            column_names=Y;
        elseif type(Y)
            if size(Y,"r")==1 then error("Input data should be given as column vectors"); end
            maxs = [];
            for j=1:size(Y,"c"),
                if orientation == 'h'
                    
                X=X+1;
                Q=quart(Y(:,j)); Min=min(Y(:,j)); Max=max(Y(:,j));
                maxs = [maxs; Max]
                xfrect([Q(1), X+wd, Q(3)-Q(1), wd*2]');
                gce().background = max([i j]);
                
                plot([Q(1);Q(1);Q(3);Q(3);Q(1)],[X-wd;X+wd;X+wd;X-wd;X-wd;],style, "LineWidth", line_width);  // the quartile box
                
                plot([Q(2);Q(2)],[X-wd;X+wd],"k", "LineWidth", line_width); // the median
                IQR=Q(3)-Q(1);  // the inter quartile range = Q3 - Q1
                outliers=Y(find(Y(:,j)>Q(3)+1.5*IQR),j);
                outliers=[outliers;Y(find(Y(:,j)<Q(1)-1.5*IQR),j)];
                if ~isempty(outliers) then
                    plot(outliers,X*ones(outliers),"r+"); // the outliers - if any
                    large=find(outliers>Q(3));
                    if large then
                        whiskers=max(Y(find(Y(:,j)<min(outliers(large))),j));
                    else
                        whiskers=Max;
                    end
                    small=find(outliers<Q(1));
                    if small then
                        whiskers=[min(Y(find(Y(:,j)>max(outliers(small))),j));whiskers];
                    else
                        whiskers=[Min;whiskers];
                    end
                else
                    whiskers=[Min;Max];
                end
                plot([whiskers(1);Q(1)],[X;X],"k", "LineWidth", line_width);   // the lower whisker
                plot([whiskers(1);whiskers(1)],[X-wd/2;X+wd/2],"k", "LineWidth", line_width);

                plot([whiskers(2);Q(3)],[X;X],"k", "LineWidth", line_width);   // the upper whiskers
                plot([whiskers(2);whiskers(2)],[X-wd/2;X+wd/2],"k", "LineWidth", line_width);
                
                elseif orientation == 'v'
                    
                X=X+1;
                Q=quart(Y(:,j)); Min=min(Y(:,j)); Max=max(Y(:,j));
                maxs = [maxs; Max]
                xfrect([X-wd, Q(3), wd*2, Q(3)-Q(1)]');
                gce().background = max([i j]);
                
                plot([X-wd;X+wd;X+wd;X-wd;X-wd;],[Q(1);Q(1);Q(3);Q(3);Q(1)],style, "LineWidth", line_width);  // the quartile box
                
                plot([X-wd;X+wd],[Q(2);Q(2)],"k", "LineWidth", line_width); // the median
                IQR=Q(3)-Q(1);  // the inter quartile range = Q3 - Q1
                outliers=Y(find(Y(:,j)>Q(3)+1.5*IQR),j);
                outliers=[outliers;Y(find(Y(:,j)<Q(1)-1.5*IQR),j)];
                if ~isempty(outliers) then
                    plot(X*ones(outliers),outliers,"r+"); // the outliers - if any
                    large=find(outliers>Q(3));
                    if large then
                        whiskers=max(Y(find(Y(:,j)<min(outliers(large))),j));
                    else
                        whiskers=Max;
                    end
                    small=find(outliers<Q(1));
                    if small then
                        whiskers=[min(Y(find(Y(:,j)>max(outliers(small))),j));whiskers];
                    else
                        whiskers=[Min;whiskers];
                    end
                else
                    whiskers=[Min;Max];
                end
                plot([X;X],[whiskers(1);Q(1)],"k", "LineWidth", line_width);   // the lower whisker
                plot([X-wd/2;X+wd/2], [whiskers(1);whiskers(1)],"k", "LineWidth", line_width);

                plot([X;X],[whiskers(2);Q(3)],"k", "LineWidth", line_width);   // the upper whiskers
                plot([X-wd/2;X+wd/2], [whiskers(2);whiskers(2)],"k", "LineWidth", line_width);
                    
                end
                
            end
        end
    end
    
    a=gca();
    
    a.box = "on"
    bounds = a.data_bounds;
    space = max(maxs)*0.03;
    
    if orientation=='h'
        a.data_bounds(:,2)=[0.5;X+0.5];
        a.data_bounds(:,1)=[bounds(1,1)-space, bounds(2,1)+space];
                
        y_ticks=a.y_ticks;
        y_ticks(2)=(1:X)';
        if change_column_names & max(size(column_names))==X then
            y_ticks(3)=column_names(:);
        else
            y_ticks(3)=string((1:X)');
            xlabel("Column Number");
        end;
        a.y_ticks=y_ticks;
        a.sub_ticks(2)=0;
    
        ylabel("Values");
    else
        a.data_bounds(:,1)=[0.5;X+0.5];
        a.data_bounds(:,2)=[bounds(1,2)-space, bounds(2,2)+space];

        x_ticks=a.x_ticks;
        x_ticks(2)=(1:X)';
        if change_column_names & max(size(column_names))==X then
            x_ticks(3)=column_names(:);
        else
            x_ticks(3)=string((1:X)');
            xlabel("Column Number");
        end;
        a.x_ticks=x_ticks;
        a.sub_ticks(1)=0;
    
        ylabel("Values");
    end


    set(gcf(),"immediate_drawing","on");
endfunction
