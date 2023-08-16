function rotate_tick_labels(xy, varargin)
    // Function to rotate the tick labels of an axis using latex
    //
    // Syntax
    // rotate_tick_labels(xy)
    // rotate_tick_labels(xy, axis)
    // rotate_tick_labels(xy, axis, rot)
    //
    // Parameters
    // xy:      string, 'x' or 'y' axis to be rotated
    // axis:    axis handle
    // rot:     angle in degrees to rotate the labels
    
    axis = gca();
    if length(varargin)==1 then
        axis = varargin(1);
    elseif length(varargin)==2;
        axis = varargin(1);
        rot = varargin(2);
    end
    
    labels = axis(xy+'_ticks').labels
    axis(xy+'_ticks').labels = "$\rotatebox{"+string(rot)+"}{\mathsf{"+labels+"}}$";
endfunction
